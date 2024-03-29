#!/bin/bash
# Usage: grade dir_or_archive [output]

# Ensure realpath 
realpath . &>/dev/null
HAD_REALPATH=$(test "$?" -eq 127 && echo no || echo yes)
if [ "$HAD_REALPATH" = "no" ]; then
  cat > /tmp/realpath-grade.c <<EOF
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int main(int argc, char** argv) {
  char* path = argv[1];
  char result[8192];
  memset(result, 0, 8192);

  if (argc == 1) {
      printf("Usage: %s path\n", argv[0]);
      return 2;
  }
  
  if (realpath(path, result)) {
    printf("%s\n", result);
    return 0;
  } else {
    printf("%s\n", argv[1]);
    return 1;
  }
}
EOF
  cc -o /tmp/realpath-grade /tmp/realpath-grade.c
  function realpath () {
    /tmp/realpath-grade $@
  }
fi

INFILE=$1
if [ -z "$INFILE" ]; then
  CWD_KBS=$(du -d 0 . | cut -f 1)
  if [ -n "$CWD_KBS" -a "$CWD_KBS" -gt 20000 ]; then
    echo "Chamado sem argumentos."\
         "Supus que \".\" deve ser avaliado, mas esse diretório é muito grande!"\
         "Se realmente deseja avaliar \".\", execute $0 ."
    exit 1
  fi
fi
test -z "$INFILE" && INFILE="."
INFILE=$(realpath "$INFILE")
# grades.csv is optional
OUTPUT=""
test -z "$2" || OUTPUT=$(realpath "$2")
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
# Absolute path to this script
THEPACK="${DIR}/$(basename "${BASH_SOURCE[0]}")"
STARTDIR=$(pwd)

# Split basename and extension
BASE=$(basename "$INFILE")
EXT=""
if [ ! -d "$INFILE" ]; then
  BASE=$(echo $(basename "$INFILE") | sed -E 's/^(.*)(\.(c|zip|(tar\.)?(gz|bz2|xz)))$/\1/g')
  EXT=$(echo  $(basename "$INFILE") | sed -E 's/^(.*)(\.(c|zip|(tar\.)?(gz|bz2|xz)))$/\2/g')
fi

# Setup working dir
rm -fr "/tmp/$BASE-test" || true
mkdir "/tmp/$BASE-test" || ( echo "Could not mkdir /tmp/$BASE-test"; exit 1 )
UNPACK_ROOT="/tmp/$BASE-test"
cd "$UNPACK_ROOT"

function cleanup () {
  test -n "$1" && echo "$1"
  cd "$STARTDIR"
  rm -fr "/tmp/$BASE-test"
  test "$HAD_REALPATH" = "yes" || rm /tmp/realpath-grade* &>/dev/null
  return 1 # helps with precedence
}

# Avoid messing up with the running user's home directory
# Not entirely safe, running as another user is recommended
export HOME=.

# Check if file is a tar archive
ISTAR=no
if [ ! -d "$INFILE" ]; then
  ISTAR=$( (tar tf "$INFILE" &> /dev/null && echo yes) || echo no )
fi

# Unpack the submission (or copy the dir)
if [ -d "$INFILE" ]; then
  cp -r "$INFILE" . || cleanup || exit 1 
elif [ "$EXT" = ".c" ]; then
  echo "Corrigindo um único arquivo .c. O recomendado é corrigir uma pasta ou  arquivo .tar.{gz,bz2,xz}, zip, como enviado ao moodle"
  mkdir c-files || cleanup || exit 1
  cp "$INFILE" c-files/ ||  cleanup || exit 1
elif [ "$EXT" = ".zip" ]; then
  unzip "$INFILE" || cleanup || exit 1
elif [ "$EXT" = ".tar.gz" ]; then
  tar zxf "$INFILE" || cleanup || exit 1
elif [ "$EXT" = ".tar.bz2" ]; then
  tar jxf "$INFILE" || cleanup || exit 1
elif [ "$EXT" = ".tar.xz" ]; then
  tar Jxf "$INFILE" || cleanup || exit 1
elif [ "$EXT" = ".gz" -a "$ISTAR" = "yes" ]; then
  tar zxf "$INFILE" || cleanup || exit 1
elif [ "$EXT" = ".gz" -a "$ISTAR" = "no" ]; then
  gzip -cdk "$INFILE" > "$BASE" || cleanup || exit 1
elif [ "$EXT" = ".bz2" -a "$ISTAR" = "yes"  ]; then
  tar jxf "$INFILE" || cleanup || exit 1
elif [ "$EXT" = ".bz2" -a "$ISTAR" = "no" ]; then
  bzip2 -cdk "$INFILE" > "$BASE" || cleanup || exit 1
elif [ "$EXT" = ".xz" -a "$ISTAR" = "yes"  ]; then
  tar Jxf "$INFILE" || cleanup || exit 1
elif [ "$EXT" = ".xz" -a "$ISTAR" = "no" ]; then
  xz -cdk "$INFILE" > "$BASE" || cleanup || exit 1
else
  echo "Unknown extension $EXT"; cleanup; exit 1
fi

# There must be exactly one top-level dir inside the submission
# As a fallback, if there is no directory, will work directly on 
# tmp/$BASE-test, but in this case there must be files! 
function get-legit-dirs  {
  find . -mindepth 1 -maxdepth 1 -type d | grep -vE '^\./__MACOS' | grep -vE '^\./\.'
}
NDIRS=$(get-legit-dirs | wc -l)
test "$NDIRS" -lt 2 || \
  cleanup "Malformed archive! Expected exactly one directory, found $NDIRS" || exit 1
test  "$NDIRS" -eq  1 -o  "$(find . -mindepth 1 -maxdepth 1 -type f | wc -l)" -gt 0  || \
  cleanup "Empty archive!" || exit 1
if [ "$NDIRS" -eq 1 ]; then #only cd if there is a dir
  cd "$(get-legit-dirs)"
fi

# Unpack the testbench
tail -n +$(($(grep -ahn  '^__TESTBENCH_MARKER__' "$THEPACK" | cut -f1 -d:) +1)) "$THEPACK" | tar zx
cd testbench || cleanup || exit 1

# Deploy additional binaries so that validate.sh can use them
test "$HAD_REALPATH" = "yes" || cp /tmp/realpath-grade "tools/realpath"
export PATH="$PATH:$(realpath "tools")"

# Run validate
(./validate.sh 2>&1 | tee validate.log) || cleanup || exit 1

# Write output file
if [ -n "$OUTPUT" ]; then
  #write grade
  echo "@@@###grade:" > result
  cat grade >> result || cleanup || exit 1
  #write feedback, falling back to validate.log
  echo "@@@###feedback:" >> result
  (test -f feedback && cat feedback >> result) || \
    (test -f validate.log && cat validate.log >> result) || \
    cleanup "No feedback file!" || exit 1
  #Copy result to output
  test ! -d "$OUTPUT" || cleanup "$OUTPUT is a directory!" || exit 1
  rm -f "$OUTPUT"
  cp result "$OUTPUT"
fi

echo -e "Grade for $BASE$EXT: $(cat grade)"

cleanup || true

exit 0

__TESTBENCH_MARKER__
� sѲ[ �=�V�H����h�X�6�d��a�3��@vro��#�6�Ɩ���f��u�S��nUH�R��@8gw�9	vwuuuuuUuu��0:���b��7{:���Ŀ����|u�=�����l>���]��?"�ߎ�䙇��șЏn�WV�/�D��G�?	��,>���a���I��y��h��q���l�_�H����z���	�ϟ|�/����ڙ^�^����������Ny��{��������/o�~�~������YC�!m�ԗei����A�F�r͛O&����Yn���d��zd��	'���2���B҆�@َ1 ޳�:j#ߣ5wL9��5�� ����_�a����tB"wJ�y�"4����F>�:nH�S2��C��ӧuhf���_�!��hBلT"\�~�	^���R�vTV3�.�l��#[�&	���nD�8&�6v	���NMοy�C��)�ip2V��ןe������^u��~9���G�OQH)���k��ޒ�g��Nާ��K7]�09" G�y�7��ȟ�CE��fL���~(¤P��� :�t�,w8����EG�K@��$��32��D��Ao�5�Ao����r�j�7d��i��^D��4,��~��h���h����M��|���rw�CX�%?b�c�%��|����m���ؘ�h4<���{���q'���hH�ծe�N�$����ͭ2� �'��@]I�V��m	e!n:	i9EQֹ���Ղ)R�����������W��Nb���?օJg�YF8҇��a��Y�z�J��L��AR�w���T1᫧��֭� W��U��log��#���jh�ʁ_��(H	�++|$(N� ��/�#@��+�M�2\/�w�'O����-�z��[|�֗���Q��,E�2�)�#�d�Oa�S@����R�|�k+�cXn�� E+d��.\{���Y[;�Ϊ�mMQ�j����$��ҙ�#'�v\���N�@#�|c#��w��i����x����<v�ވ��m�m�`o����>���48����նk��څśQ{�z��4��a4r���J:�X�X����v=7j�V4�p�&�E���.}w����6�?5��R)j��Sp��:[0-���3�������oL|pH�ӐC#J/�	P |>���C�U��+'^�(��o���,A��ğ5R聑aIA{b
�\�@��5s����N�U�b�?��>J�������}����h���u��!"��l��e��{�)a��C�����R7:u#@8s��?�����ӌ����sf5crfϜ��*816� ��W��0h&�?���j׺��@�kߵjВ�n���tc�=gJ[�S��^�=��#>t&@c�2�j�����Y�o��?"ѳb��� �v8�� �-b�C9���ճ�1vVæ��o���)�>nֆ�A ���Ȗ��_^3&�%l*x�BiP���[�N�ʲ�� ��j�n740��X���me���V69!nq$?������f��HF²k�oP��Թs���-��ż,�sU�O��Bi`�_�0���#�H,Dp;�X�pʅ�",�V����ܒ�tmr�b�Q�������wv�#� ��x8�C���ݪ����=��ビ���c(vn�Y�'.ԂJG�E-lS����EC+j����'t?SЄPn��B��Cq/����[��'K}��;�;e�K�֍5�zO4Y��v��-u�PG#�ȎyOx?���.������ ���4,&,8�IQ,����E��K��W�F�x2/P��su��R���"1�u���ԹXXy�.���NX���:�O�����;�nt��F�u+A���2����q�6��?��3�;��.���K�)���9�o@c8�|5sm�8g{*�Lo<����@ֺ�}�����f�>���5��s<�c_�@����[�η�
/��?-��IRRF�b��Bbd_8gC+��F��e��������p�E�+2�6�X�sЭ�nڢ����9���+��K��D3��O�K��l�3���7e �̝��G�$3x�<r�c �m�jo�lg�M��R���tB��1>���>Q��*l�F4�[%Nu;�׵:���0�7����PZ4 X.)�u��ϴ�OvYw��,��?{{���������⿱���j �{�pxAG,#�1����]7U��0�k�+B?���Eީ�<2rjӏ�>z�Ծ���6��C���-asE�~����4lg����Ti@'�G:�L� )v�ѣW��܇ӉG��%'�k㞹�"htR|�n���rHX����v�B�P!6�'�NF��ߪ�}�O֫�ϠHXq#��塐B?"�ce:����:�'�׵DĴM`��B����m�~1k����N��NV֩R�Ϡ݋��v�̚�����<2tA�
|��L|g��v�P�IE*�'����i[\N�K �+*^N6��1Eg������.���O��j۴X?�I�,���6����Y����E�]:�p7}����63������wO"e�N�ߏw^�����yKc�D/��T)nREs�P�����<����<��N9�a��f���&��x�o��Zfx��^���:�ⶖ��n_ά��Z���V���DŢ���|ҷ��'��ѫ���o!�����7��}r��xw�_�t����A�aY���a��h�����l��?[Ϝ�v�?����c���:��x�����S�q�7&Kj�H���9��B��tc���uf��=sUb%�*0�P))N�*WTA���Tq���V�����W��%�Sgvk�m��I6��6�Itg�N����ّ�@�&���͵�_��Ǩ���Q���Y@�� "������d�[��b��+��;%�+�1M���Ot/1�~�@S~hڑTAD6P�!� aD��0S������2��T'�#!�a�o��^pJ?�FM��!�ڏ# 2,ç�X)
�X�����y+f��F�n7	T-�'d����m(r�=��V��裇T��"�7�_e����<���}��u/�)�*�X��e�L�e2'�v�b���z6XҼ|1-�̜0�*�+�^�vP���u��[�^\�v@�� t/iR��*���܋x�Ե��g<�*
s����s���S�P�����D8#��:܃� T�
���>��,7�H�o y�5��HP�9�$,-g����6:	��C���Ɏr!�P-�;LotS|�L��F�����{�p�t$�Ǻu4@�%�K7�e�j��9Q`=�˝���>%�?����߼�ќ�^��V�I/6��	�i4XТ�ъ��N@G�dY
A�S3)2&�`��UY	0��h.�b%8S�S�GV�<����*l���J/^k�r�f�X�^) �� cs�������G&l|ѐFä�����Fjʒ �EDJ�x�����2��NMX܉ �E<I{��m�h�c!�4��AO�^ �G��qG!�g��!�w�ܲ������*~mo�B��ž����:��������`O�b��R̪~g�p4���Kr`a�Ϭ�R���F����	�
�	���|��t�������d����>QNK���w�*�s�;E�I�����d秃���&�s��I����X���z�Ÿ�tp��8rH=���Խ���K2d�:|�p[\��J�ע�a.n��K�#o�	�M0�s�%QϢ2?u}��ա�[��<^6�'��>[0{d�xp�brOsM�A��L����ET�}s,�&���³�j�e���%�,�t���z�&�I��>�Z�9�\�X
qy��C�"�Q�A��g��i��"��-�:��>Ns9�D�D|��t�ǃ���'�X��V��:gࡠhEP#��Aq{�z��$���a��0�tyr�s "i�J1S8V�-IOVެ�qKI��ۨ�:1�c��ڞO�(�(��/O�ʵ��u��3�θ���=��U��m�R^�sw�����W.(����@]-�^N�*�Y���405�S\��1ye�^�uA4Cl$�u���]�܈��u�B0��b]��fg/<>1�n<o&hKO��[�k��T'���^���'�<����0�К�+Y�Y���8��)�2���?'S'L�渌}���#	&R^O���Ah`pf��IPy	@��ܷuD��	(����;�s'᛽p�-9X��Y�p�݁�Oy;EUS#�����ͬ�/�el�qVz^�]�2����~2��܋� O&�c�B��f�e=X��-?��o���%���K����S��+��-��|7�Yڕ�Y�\�K�,�nS�gfq�(�-�wK%,q�m�=�̅�n%`��O|L�r!1�)L���*�N�}x�J^��"ܻ3�A�=���aH�Y-�/���ϸ���*���*��#u�����f77Sg����SR��6���󔒛�x.�V�ߣ���;p�A�X�����AG�Ȇ���2�|����ZT�!{Z1��H��,��Y)s���XV�\!�)�B�r��Ky���&5!e!��l#�y4�J��8
�`j60��iA�j?? k�q�4Mw;)M�(���܌�f�g1U�RL�g�X&�p��b�-�l.>�8S-�%W�Ä\�()q�XH��{]+I�Q�kɤ/�H�gi�`����;q�u�Y�ݲN�M��N��9�bmY�u�1���H���w;�O�4X��ك�*¨�#& ��Y�CK�7�[�`��>P۶[f���f��WP�G��e����H�vDcP	�0��O��,�BM詏�F4�E��w��6��a&���Rb�dYI�L��-|��9��K�a�Q��:q���@� F&v�~��y}p��	��yf~T�����vX_��t8���34so<��c���Hr~A�a)L��4d�EK�� �.0�/�X0ʢ�W�!<�Y�NE p`�4�
���GX�9��¡�"�M�*R�e|��Hg�Fj�\��O����0l���?��Ħ�͒a�����4�
q5'[�ɸa��#D{���ߖ"�à�Ԕ�ے���bd_�����v7 �	��S��%Q�\:P�v�@ �\��R��|��ҁi��d���|4�*&KUL�B��
T��`j��J�3)�j���ɸʥ���&��-EE�}󄵛��C��T�1�xO~^��NR��$+
�ڮ0��F3.��L
LUg:���^�`��do2����#R�7������ 1s�ݣ�Ũ�����>S�F���*���S,#�!`�кyC@Xb���R!f{�[��赛c�6t���2J2����c�q�E��\K	�2�K�V�۩��18�����<e���`b����K4Sf���@B���V���l���'�@s]�ZD͢���G�v����;v��,�K����2���,E�8S�7ʥ���Uԭ�L����eӰD|����:Q�Z����D)陴U���[�'��y�c@AB������ٖeS�f���<9p]=Ȓ�~V�o������:��!�p�*A�;�D��r�6c�͹�u�S/�T����3�Ն���Q}���m��xRo�6��'���������2�H�|>���Ǣp�ϗ�9�Q�����e��ȿ�iDb��v0�#^��'�������ק1W�O���y>�{�_f�(		�*�C��3�4��\sT�3���|�qVw~��?��)��6���n�'Ti|�	MG��#3��aٞ!şdM�W��J�L~�գ�d�Mg��J^����r�H�i����a*���ژ'���*$c4k?��8�y�*e��K�LS��V��մ ]:�3<�r*^+�LP��^�qW����k��u���m<���~����.�/w^�L�X䗠�^���`�'U}��L����J���F��+Og��a��UQ�$�BW�Wl� �l�,H3�I�Z�d��ۺ����])���$��,�R��J�P�t�b6��ٯY�II]k��[,Nӱ�g�	A�����G�g�E{��_iƍ�!g[j���O���z&���g���4Ģ�ϸ0o�ne��	�y�X�vg�.�ޚ����f�I�b�/���l3��ߍ/��}<�o�2���"o�R��R��@��� 5�f|&t�3p�/��H��B(�ĳ:cf��`��h��Dٗ-Ip">�.��I��m���~R��7���#�.�[|�k�/�����xiv]�,9�s���Z�[��329�hnOA*|��w\~��%�s�{\����<+�̆�[��S(N]�Os���[m�=�`�&& �Ź��������{�#<���HI�N|��M�G��n�S��p��LMPGaY����5�q�}��G��yG�����Q$�QG_��dR��wu�w��u���f���g������c�] �}��Q�i�{��b�X �E1��&��z�^�^ys����;j��n�|�j3�V��zX�-���QX5:.P�7���@����k���[����H|����l�&ǣ|�[R(���:~�Q�gdK��}����������q[�	��E�+��8{T�в�;�O���)���<����Y�o��6{�}Z��6����$ev�n�B�׆���]�[���5g0�����9�Ty!�:w(�x�������`���=����v����w�JG�"�K&���ݕ�3��N�x��@iv������?m�g=��%��"}����Q�27�|�>��<C��I�!�ɥo��(������	�S�~�;��{�d��C��;&��g�{�{��!���u!��0����ЦH!�
7���ٿ�i��E��x�Y��I�I��`�� ��R�P���� o���,�Z���5���u<�<?�r�c�9*9�� ��Atj�m�}����+�',1��>��р�h��p�k���~�.;?;`�)9J��SǌDlʰ�Pyd�4b�d�"�����jV�����vr�B�F� �N�@x@;S�����\�?^0�u���S���D�����F>�����'���/�Ќw�EXT&<�֛���M`�������0�އX��%m�h��cv>�Ǟ��2�g���g�d�t���!2 �w�}�۳w�x.�6mX����j�U,p�L�HH�=���b-?Q��gq�w5�%B� �B� X<��HR���.�8���]1��  (B����kw�F0ֺ�g+������?���L�nwO���$@] ˸���0f�A,YvL:�(� 
`�An/&���z4��B���W�JaO�O)n4�uq�)��Ai}��__���[D�NzWn�^�(H��m�(��:��|K�]�~����;}�d��O/p�
]�0R�[l-�A������E��y8������z�7#�׋u�lO2\�}AZ��5Q}\l-k�����`����6mR.�_^F�Y��L5�I|�*2L�W�w������.���n�A�!�B�=o$��6ǫ�t �Ց�����f�Ԫ����@��ʱ�x!b��4�r��~����?*�1��YWγ �WqA#hl�r�˃����ow��<=S�/�x�;�Q�cs�������b)��>��{��#&H��D�!#��k��S�G� M��C�[�p@���z.Y�\<_,?�(W
�?g'�������l��}<[SP�CT�v���.��H���
~+n��	;�� Sd(�Z���@�z��d�n���`�D�
�*�K"�W��S�-��j#E�?��*�lU��=�ui�M���1�� ̈́g��L�y����\��U��5�00��6��0�v�C7@G��,Ux��̞�w�N�`�JsKW!ݱFJΊ�CU�T���) ��Pm�Ik�D��(�d��]���`�W�rQ*��)��e��|򐕵�4W/�(}��&�F�j<�����$������0��A�KA'��A�{�8)+�%�ߪs�,��n�wAޑ�V��\72�,��~� <�QV����U6���P�v~4��0�T�3�̐���I:����v%dS-���ZP�|�� O=V����C�������2�'�V,�X��~È_�q�H\eYO����o���������s�u{׵H���˕��|�m�2�Q`�����mJ�̜`2���$�g(Y���+����OA����0֠��m��z
K����JbVAc��BA�{&��*����B+�%Z 5�$��Tc��;����ꗒ�Ϫ�tY�y�k�~�FP�i1Y��Ҝ�N�A���Ygw��Z���JCE��h�f0E�������0m{��157�α� Hj�XQx��+dmd�I�e�����K�L�V�C�Y]ns�b��M�Y?�Z2�#-�z�S�r���tXf�ATy��_���7A��M�(ol "���ԩeז��>~S~�N�[����3n�n�-"���w?���%���}։�x������������pcc���!����ȝvG<�4t8i&�K���s�3�+���+�'���e������p|���	�1=???y~���W��c�u�Uw�L&����v}O�~�t�ov0�Xs@�#G��S��K���!��ٮ�;`�P�;l�Zc��_s5��#��M��Y�����'^h�Z��D�){�k6o|)��ۊ\Z:��rQ�&d~���M��ƅ���������O����g�;�Ã�g�3{��?6,��}.W<"��q����r_�(�bҵ�+��֭>�?�?��a9ґ���������.";W"I��.�p����E��T���m��Mם����z�g���aR���:�x�� �xҧ������!]-��AM���7f������5��e�����9�4��S�:���E3�.�@�!�uh�cN�*�@�M��`�:�|(]�\��)TiuwNa� �^z:Z[+\ٙ��=F2�8wn�U���)m��O�j�� �g@i����v�;_k]�n��U�)���T��m,�}׌������������v��<;�6�#�9f��:[6/"���ވm�8��"�j't�����9�7x�48���ŀ����Q��r��i0�����!���ǲ�#�v��w
��.-v �Q(�H(�C��k�%����X0�l����`H����KR&�|�MWiژ ����� �>��%���f�Е���;���� ��[^����%z �%G�>�n�ig;���霵�蝶��"=��3�] XSw�^u�sŧ�pL�ľ�87��b��4;�ƻ�$'���q�m��?'��)� :ݕ5�ܑMf�o''>F8S�7͔���o��"9��??݅�^i� �@�;0ᶡY���	����T�Ȳ;�O���!�F�H�%�P
�$^m9��J�c���.�ZT��F��`H�ؗ���u@^�;ώOw:8�Ŷ�P젵a���-�H��(E1[�e�����醶�sG�d������ ��]&�gΆ E�=��d�aP��F�ǨE�GR�B��
��
`��],m}����W�#J^�,ժmX'_}����K�2h!6�:��8����m1����\)R�Bi���Kؼ��J$no��-ہ=NWz�J+��/ʐ�	7�+��L��\>��������*e�t��@�nK��~쀵�e�?��@��h�-lJ�7�J�P�0�v⡜��f���CB�BZF��D���~ica��BF��J���y
eA�ҟ$
|$#$�i���Ň2�#��wH0�����=X��ЪR�92E��G�e�2ΈQL�v�{+-�Wf~�ma~CAo�	s�m��	��ޖ���MZD4m��qϻb�E^�d�t�+���e��e�j�-@����=�fx�Jl�φQ���{c۾	�n����	uS�f�1I�m�=� xP��ʟ���P��i���:É��04�5~CË�v�-���	6������%#)�����;ҡ5H���K��q�ZD]��$�����<�� ۠B�~���k�`�0�A�Aa$UZ _l����#�����qM:��Z���FOYw�ƪ���d�~w�'�@��^��ȝ�Ή�ʖq/�@jB�W
�<��E?���,`�\���`��f?�䏟���	�]	��;�x>1�N\�0�a��Z��l����b��Ņ���Rz1͐���E�����@m�v����me��7)I���9��r_ZK�e�Z(tx�c��+12�][���v���}BE���t�̍���5WWG<t�'7�� �������y�[�A����������f/� ���<�jp~�o����?���4-҇Ku�?ټ�nʸ��onnnT���>H�6�K��mB����P8�+�נ��tw9���Ȉ�k�]��q��\��dL���,�T:�w�i2Ń^��R^�-Aep�0�R^�Gӏ���r^��%Ӕ�hFK��17R>��|0Nr�:���]:�!F���%A�6��ǳf	0�����˅H�팂�谥k�i��R�9B�����%v7�o�'��%[� �x}�cyr{�G����P�����T�m�:����H_�&��7P`�È���/C����X��إ�^`�aW⍈n��2���������MnK��BӃآ��@������yE淞;��w��o;�,)�23��\�0���a���fs9�q�Y�QP[L~�9;}�H(n/��:�*{��r�.b�o*7�Uٵhs��E�խ��r �B����b���E���:����䷍�Wȯ+:h���
��Fq]�y��rnasx�(����|���..�$Aݸ��/�R�E�q-�0c9��:���fͷ��EZ�EZ�EZ�EZ�EZ�EZ�EZ�EZ�EZ�EZ�E�_L���� �  