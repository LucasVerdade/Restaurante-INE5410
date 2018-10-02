#!/bin/bash
# Absolute path to this script
THEPACK="${BASH_SOURCE[0]}"

if [ ! -f .submission-checker-t1.sh ]; then
  echo "Rode esse patch dentro do seu diretório t1/ (onde está o Makefile)"
  exit 1
fi

tail -n +$(($(grep -ahn  '^__TESTBENCH_MARKER__' "$THEPACK" | cut -f1 -d:) +1)) "$THEPACK" | tar zx
exit 0

__TESTBENCH_MARKER__
� ���[ ��	<Um�(l�Ҡ�Vf��1S�)!��������S��(d(�̢�D	E�!*sJ2QIQ2}km��������9������S{�{��u_�p?�u�v�`�t�AEyy�WFIAz�/
�r2t2rr
r
��2��<Yi%:@�'Qk@%S$ �C`�~��_=��(��hX�K)$4H躘�Yٹ�X�Y[���JK+K0$�	3i@��c(� �:�"��d��
�������:�Dp'!p0#m3�	 zd2����_H�&�I>h@$! ����ME`� ��M��Ȁ$@��h<
��B �N�L�8WZ���A� pTP(�z��#�T��E����  98"� ��	>OAKB�A�V|��S��
�B�5�ѡ��&�W�eDfeU_�RA�{�H8D}~}6��  ��B�p`14�C��BBc�i� z�H	pxus1p��BT�����!Pd$$D �GS����Hd)��G�Q*� �*9<�_��G�/��3_U�a+@P�8|X�����R1X�����jEeH�ɑ~W�� H��=�l�`,�E}ADH	�K"!�H<�& ��9����Qq|B @���1T�7D ��U��4��P�d�'@�xpP���B�<$d:��Qh�����
H%A!S]�@H	_�CH� ]eDL���<�Le�Cb�<�4#�D@!p�vq�n� Ӑ�!;���f5h2"�L��	TYb0IsC3S{h�������ׁ��� C��&�d8�7�L�ςL	�&(J�@��p^�X 	" (
�]��BlE���
�#��b�b����if���1$H�aElh2tV������/D-�ү��'k����*nm\�ED�#V���ᐴ��J��`��U ]@��@F@�K�A�j��^���*M�4W_q|ڒ5�Anޭ9�$d�+VB�w�F?��MP��Y�-�M�� �рH�Ƞ�i���)
p���� {^���"�� C-�+܃f5^!p���8h�U�q�/�I���F
��ݣ`���::b��-�	[4�D uO��ԑ22���y�[X�� �B dƊ�#�����A��� �CZ4��)4��z���� !�s�ח�A��<�\�ՖP�F`!�]]!(
��M
$����!!����E�	���&
���Z�!C��g(Y/zP�DP,���h�A�0�Y>h,  �0�l@� @�! gÀ1��Eup��3@Ƹ�1 [@�,�t�Ս Q�x�h����e�F������*+�[��/���7�ԀC`�Q ��;����innNB`ƒ���{ -{�H�`��(,dʦ�J>�d q�ZL]ke9�n���{%Z�
_*0VMW�����5*AD ��$I�D�	GD��2��\H�HZU�q`	�����8�T< @� �$Ә�]P��gQ@-�׹����	��� c ��h�$ ���������@I�R�_�T UH��Ր��i�0#H+�kmkZ8ǡQ�ϐ4���12��T��� �*{Ҽ��P��O��*��h�o�D!m�.F�/��C��d'�B>�V���P���Ip}��[�u���l�3ע�\�	�]���%��ۅ��O`�{B���E��{@M���¿��䔔���)�(�������>)0KA�tjk2����
���� !=0>h��@���щV2��T��E#��[{ ��W����f���b��eb�ee�`2� ���	�7 #�h�-��\���b0���\��P��~�I�x��0 @"(� E�������D55=3}��Z(RS)�*������!���Q�uxQ��H8Խ��š1 �  h��ӆe�TW�A�X����Y� �#�)�+�p@@��Ta�3�aQh���Y��h�7Q�U��i{���Wv�vS]�JB��)����?�H��_�*Mbk;��"�p�>]A��P��,S���E�l��Jf��`�PH�^�����=p���z�_F&�F��Ѐ�)��32�72�S�Y�"� АV��ێ����!m�YEQ	 �n��R�2XFlEz�j<�zu.h�����)�,�֡V��_���:S(G��BU$�,�tU[ �[R�T2��:�/y�̢>hZ���A`1�j8hdZ��u���2��+*�@���w��8W��V�Bij�WБVvb?4�&(2�e���0@:� �M覫R���	��m��	5�4��%�d��DH����?�:����ۯ>��,�
lY��E$
�~@�
~�@m-K���)���1�u]-D.�B�+���إ!�F� �"#I"fe�g��s�%�,Xj]9�]@|�VZV]`=�Z�J�XPz?ׁ*�	v$PJ��( A���SPzv4aЬld�����4��#�f�h �����E%��D�J�"�0� Q0��;(�� � VV�RGe��E �(X���C.KC�!��Q�D��@�c*�?�jq�OsaA�;	�hf ��h�ʡ������
vxe���sUW��Y�B�u�03e��y0�]������:�n$~5謘,d�&-��m�5À��kx�����G�\���&�[R�c�4��`��6�/��C4v!��!`P`��;P��"�Y�a$*O��� �V�B ���PW�`�2�lז@�(z0JA�!�P�C��604;��.I;��jJ(��R��[��V�
�$7u<�p��i`�����M`����?
��X3Hk<Ԃ�d��M� 5fD�8(������v��uO$�����s��`h�j�Mǒ��h�l�D¸c��_�&�N�$��҅�	��++H���v.��Z��`�$�/ ��
_i��x(� ��V��BJ@�!����1�:W
�����7H�zΩxp`�?���XV��#�l!�����
��?qy�wq��Y��Tw�
�f�����?����v�t"�Dy�í^C��z�L���B�B�;� ������7Z�Oh��g�/��~2�g4��{�	��_�@�Zum�Zf\��V`�Ξ���
��#�0��h�L"J`�й(0 .���=jB	��n,��p(�Sh�(�'�J(p�dK+Vi�@�H�'H8�
���J���U�k$���>�W�vGS@:�1	1��j70��AY���`Ɠ�~?�)�D0ʃ��;	��X�8��rq9��cf)�/�J������P���� _�����V;m�c,�@Z�J�5��F`�S<��ZM� =?"(4�7鯓��
r�����iۭ�l�!�И����~Ҿ��H�B��H��I���W�z��2kF� `Q����o�V�����_�3ğ+X�x�(������+i�Ax�P9..Vz�V�z�:���,�Y�����W�z����3JE�/���=^��P!�s�?�H�.��%��@�0+tv� a��I��
��,���${�拇*$��*��������B `�?G���+�q
� ����k�M���\*�'=0QI����j�@ܣѿH����-�$�A� +G�?���m}�M���36ijj
��T���r԰z��®���+CV��Ѩ���*u���7n����"h�u���I�-��s���H�y�s�ؚ��[�~õ����i�O3%����o>����"�V��E��k�_'������M���֥�B�R�n�k�L�%@s4��	�a -hC��?X?5Y�:��:mCi�O�
������#�z�O�r�b���m����V;	�*��Lէ�'���i��Y nW�M2&�5-�E�\�B��mA��~�����´�̭��į (��oF_(�|���Ջm��K����˫*-��{�2��|�p~U�jb"��i�v���ד�o���_�[��dVw�
StK(��ˑ%���P.e�5>/ǖ~�&,G���pԌP�o�K_D��r��=���u-/��\\"U�>����A�z�l�����d��,�S���-M�}�pl��U��|�����糆��I�M{C��p�׻�͡,x��#'�F��M�v�^5��9O�?/��f.���z>��qH���K�ⴺ�1'�q�]�����*��-&�=���'"H���0�Ю߹i7a$�p�4JCH.T�k�z�M���C�w�;�E
��;l(T'4�6(4()*�3@+0}�n�u9p3�/�FZ�ܠ~N4��L>�k�Xg�/{�b�0D���OK��jk�..�g�ږY�;�\��P�����j���gC]��9;�~��q�GD괤B��]�X��S�\�ꗞ<�f-����u��� y������`.��K�]��&����Gݩ/��Wqua��&�g?ؾ ��9~̿:�e�$�D���늗u�'O�����mXϟA?�����`zǛ+l�C�Aog��7"f��ҧ�i�:@�����=���C��>}�#q?.��x��@����H����gv����s�����I�Cu���,^��O�L��~��{g"E\��5�d�}(/�|��vtzje��D
�_��l�G�ZG�{����
jt�R(�i�S�<7Tx����r�Jܳ��7m�yx2��� �=�F�g��Yp_�#���Mcþ�}}M��2��Yߺ��Id��>�E��满��!z����a6z��so�Sc;*�+�b&����0!Qp��1(�;�6�p���&����\\�A�_�� ׍݈"6C���d�J]�Ê�1ܜ�V�=^\�����&�YNj���o�r���8�9-U�@��̄К;�-W����X&P�,.�T3{Y�t��گ���Z]U���9�����ِ���/�|�ou:/WeY�g�xb���Fc-Nk)%in����FNU�©=fױ��t���3�\������(شpn2W>jW��'���momV�_Z�}��<�1�J��^�[f_���?=���� ��38n��m4'l�_�|y:YQyj850+��q�C棊��c���gl�N9��<)7p�.�ay���h�r{��jr�Ǐ���3r��]wċ�c8���0�I���_~1�)�����A~�Zu�]��^�����_����)�Fp����	������6"K�1��埬ג�_~���mճ܆���׬Of�RBG��U4?�|� �Ǡ��̉�qv��Yr��x=���u�M�[OPuv,�rF^��(�ycy}_#�1�@Os��Up�e���e���3o�װn�Ri��ҞWQ��8�����md����������'=zt�*��� O}�z����u�0oM���Xt��.���l�D���i�����$8�1H��mIz5:f1��6��Pl��܎f��Zp"ĵ�y�q�4���Ż��C:���e��aY=�z�b"nє7x��_���wĈEg���vزD4ްx5_��A����Z߫�X�{f�ƚm6�����\��av� |�څS�g�D;�y��N�Ok��l:]�?�xM�B�c�z��!\1�L��W�f2�����4U�	�M�\JvJ��՟�ʫ^λ}ݫ��_����bʄmս������̮v&��L�����6HWD��2�5��1
��.F${�\����3;m���殇�b��=����i'b�d���̠�m��x���fֻgYO�7�.꿛����)ʕ/���T�r{����OZ.���w�u��4��pT��C������'�woC���6��Q�l����;_.���SdJ�^߱p��W���_w���忱W�ۗ�Ie�9uх�f�J�.\xV�{��y����3�h���M���������7Y��!d,��X����m��Z�mQ㝈���1�e����Z���g���ec��q��62��n^�d̨�V�<��{"��}_5f����6�Gu��,S�tS3��C���?po�,�{k�kYe�|Ъ�,�UA]�#�{�=-�^6�Z2����a��#tx�K��{���,s|N�E&�V,^��p}���_)� ��Y��i�%�NO~=��T�Q�����i'���8n�Ԑ��gU��
ԁ����|uE8���*3'��ޫ��P��m�g̨��4��bX�}vO��ȈF���'����r�oO��m��"{�g��ؠ#bn8/"=���źmq����YO��=Q�^�7�˃����*D9·n\C=�H*�]���Z,�݌὘(�32
�~�����:
����]��Sw`��/��_��Y�N�~;!&��\P#�6����³ms6�S\r�ӏc�v�&k���
2Pَ'�_S�Gc�*�pzݶ?��V�jJ��{�_��Y���%[��?�*���.,&w��>a���������i����uq��-�Tg,=t� ���A�[�]��>^�9_��n �E��2��zP�:���ճ�r[���(q�\x�H��)}H�ܾ尾�I�[F�S3K�v^�|���n���,�g~�Y��s\nB�*��A{`�6��#�c�,�gq�3��C���[K.g��:Sힱ�V���k�jz-e) g�}�Nsy��4���r��R�噘����4BՖ�σ�H�mi:�{�w.�{x�`���Yg�d#o��ܷ��#uy��=����o�֑ɝW����Qv�)�ۭ�l�Ph+:� �b��^����)��}B����$�>�m�3�%�������ߴ�C;Ԕ����'��%/ͧ\_d��?�!���ipQ~��p=�o��)�{i�/�O��FQMʐ',ՍM�^�?���}i��5糓�.�y��󿼀~T�Q�/�ؗX�4a8��y��|�lG�s��#c:g"�gD6�ao�*v�:�`ä��h�%��J�&�����7��3X��a��x���V?9��m���6�ϐ��'��k3&��.��ه^nZ~��,{94��z[`�	҃���y����*�J�z��a�kR���Lyt�7�\���V`n�&J�n�\���$IG5�ޟ󮭼��˶^�Џz��_8钻<�ʱ-���c�����	1�ǂaɟm��w���N��z&���χ�x�r|Zw����<�`����M[�b�ޞ���a~Xc�� 9~^�����#��yB���p|����N�#�����{w��	/6�~��<��se;�_��T�"�P�X����ٗ�����)�84�_����#�?���-�C�*�wa;�DVm�`�f�J�uh��5J#��b��b{9��B����	���O�KTI�<Vޠ�TR��|��Н<�F�[����D�M��>,R��w/R^k~$�	#o�]��xHy���Y�8�j�Lrq8�t橵?�m����5RaxBd:����߰|-+?��ɶ���F�Z��GG��W�����H�RQ\�WI^�w7ʥ_���s4p���*X�>R��%�]�qY�wGA�X�ֲ�׏v�쎹Y9���.�܄{�S�~n\���Au��0ٹ�R˃��K�{;j�"S&On��^!Ҍ1J��C�*���/�!�l'�B�K��%?eΔ@Y$*�١�#Q���
�g����ٲ>���Hi5{5?�Z㴠�~A}����C>��V�ۃ�oV�~Ql��7l�3R��T;._W=�y�s�I�=B�B�(p�_����"�"b�)�� �a��#�/ּ����Hܷ'�vwQ�'���������o(+���:�N����_z��c'ѻ�=��J�,�����8�{��nw��[�ܒ�0QJ�ߨ�ͯu��!3�ϥ����3�g�3��,��a"�SӎG���M+��G�s������"t<T�C��iD^KG�+s#9ۨ�u��F7�s�?����f��|�lSR�a~�Җs�U��V2ws^�e��HQ�?���벌vқjļ�G�V��9`��7������*���g]�R�����)����_�r�dv[Z	���:�v&\W�\�.���D6�۷�*�6��в+��_MN���<��u;q��<�&���a*�9��7B1R���-���?�g�J��*��f2���\�N���A|28G���	�"�����}��2������j���y{��=�&q)z�=5a�ٱcԘ�Y�i��s��A �lGl��ՁL髜�������r<Q�7��Ir������wMK��A/���ճY�Ї'�/�j�js���z5������+�	ݥa��-픯�ء`#	�X|h�l��[��6K�qk��'��	6)�'7�{<���������w�:�y�����gmy��{��ӽ�o�6��r��-�!l~���Ѱ=}����S7�E�~0�k�����3�!��G�Wdb{Ɉ'h�g�F��$4e,D<��y��o�������xd�P��U3�yc:�?��Y}W̛��9p}��
8wi�Q���⿉����f���ޥ�{|��hV�����/z{���/>���u�ܰ> i\q>�(����PT��a}C��#b����<��Vz �PZ�7%d�V&�<���k|>s���y�� =��'�T���I���T�c�"�շYN�O�ȟ4JwY���M7����3�����=���[��;I�et�rOȈ=`�J��]&�6�N�}I���D	�n边eB)�t�{Q��G9�s����e����)���ev�N���^T��w�}�$���~��އvr�(cтI�[���Sb/k}t����/ ΋]��ds2�) r4�p�z���)�5�?%#������*[�g�:�K������w��n�r*F� x�r���|ӪًJ�L����~�}����-+����V���Wަ�7t��;QO�d'8G��:9��f���5��K}ޛ�z���@��t�Ԑ1Y�}�{�@�ōKe�<]������#�H�+�v�<>�����u�Gu�v�\��o�ύ�V���N���y�{מ.�RZ�Y�J���`��B��'Mϩ�x������4Z��W��ҫ�k���{6+����H�2Զ�f׋����xM�e?I�D��M��ܿCbȌ/�;NgsǊ�+�m�Y,�ѵ�2C���
�qI/qsB�x�Kҏ�h�BZA� ��.'v�3w�����<��d�Ђ������S����yu���ʧ���m��v��r����_�u���mʲ��H�S��	��F�?��K$�^ y�ق|��r���>�}�L�ɉ��_
���yR�5,�F�{>����j	��-�p�`��*M����l�-����NL���"9)���-k,[�8y��=���|9G�k��{�	K>���k=�d~��r�ͻY<�Qu�'�嵞�ddmz]6ۯ�]�u{Y����	���`(<�������.Ohe:���;�m����wI2�xo71�Ƌ\5֒�
��W�B�Q*5mf����٘f��"���^���#HXߨ=��_[.�tY��ٻ�zF��%�Y�wǤH�'�%lv Z'U/��.�%"�����h��)}�m9�MƯ�
�7s��&(�s��2�>cY��.m��#^�MK�/�ƐQ5ߋ���g��&_I^���Z���e$��l�� ��Os0&�Ա�9��&���7+=��K~8�=�"�L�n�.���_�+Whg!��rv�¾7�z�����CFê-��x�����̶�PW����.xs͑z\<��ӯ��tP��?�����|O(6Z_��=����n ��G��X�}�Kɣ���w�yG0��g?"<�Q�e̔����6|����p^tǶ-[?�&w^�MNe�9?�u��) ��/Vbd��=a.󥍄=.��.�>/�m���1���o�Ի���4j��{��k7?�z!��2ZKor�n$9sڹ�~ٱ1����KL>|��|d�q&Y?at��{�%D�+�#g���l�m��t�����r�o�jQ�>���Z�=�Il���W���=��6�����=��/6�]��:d���i[�#ܴ�4�s<�֕�8��s��^�Y8[J��F:m�5:��Z�fL�r�������8cm�\I$�ƣo^`M�w��:S��Oxb�nj8�l)Ǭt9���З��5˾_����L����i�/N#�_W�bm�(˗"o�53�;��T��+
��t�.�$����~6��[�m9���ž���M!VӇ��~i�b��ٺ�_�iY�p;�%[C��
�6��4�[���U������B���A���lK'��ߩn� f�7ɽ|-���Q9�j
��N����}�=7��3{�U�7�(˞/�el��9Tz�G�n������'�}c�#��-�-�Q��r+!EE������W%�V�63py�v!�A��ܥ 02iѾ����%����K|���Y�@���� �P&���餑q����q|z*ޏ]�O3y���������!��	j3��;"L�:D*���v�b�<�6-X�4V��r� ��*�ɧɉ��zJWQ;ʥ0��+:w�����)��[:�/1}h� ������mj?������i�c�;/�:�+Z���ԡ�n{|Y�kpR���q�����j�d�ű����F��I���`]�~n��%������wF*����\�a�&�3ĥ�w'/�.֎�ۿ`�V�3���T���<�[�6����wt�|�G�Gy�'�O��k�R��mӤؐ���hPy��O��Q.�O\��m�S3��������c����ĩa�H�w�f�����JV�f��W��j����l��k�a-:�X|�p��W>��pZŰ?��a�;�p��Wy݈����L�ߛ]@6Iʾ%?�{bs��!�c���ՎI���SoW�J��ޛ�J��ɒr��'��w�;�v��YuB��%���.E�5��E�Y��Y�I[^����8�`��)y�rn%ӕ��g��F��$�����;�s�����*H)!G"T9��f��7#lq�xי���Z��8�Wk|�
���
��v.���.���
"���Rt���y��}�g��o��/���|�^)悵�A�t]��h�'�dݤZ]5�:�����=�p\�:�B��@ �4L׉���W捼���G���j�A#O8c���"O��ͮػ�6�m��{��xI�����h�X���Sk�d.����*q�"��%��o�T	<h��r�=���L�C�6��}=:��;�dPzss25��Cu��r�T��a^���_�*KU*��O^����Ǧ���>���Oy����ڒ�c�&�zeؽ��1Q���ں�4Q�7���1�.=���y���.}�0L�O^�c��I'69�-wn����'ߊ��oֿwy����@f�����;M~�;4�j˼UZ�� ��Cn���5���������� U�L�|~����{�=�l��Kl"���4�k���}�Z�������1���,.s��j�=����H��~#�7��C��o��9��Q�a/��������R�Vg��}{�&���7�����ẚ��sv��=�ފ�p��۰J�G�L3����ї�{�/��	d��^�j52,R��l���������-�{D,c��wF���}!tRJ�G9������P{/��h��1�K����G�O]��[6�$��U���n�͓����������������"fm>�?"D�n�!�?+g=��1o�C�u���zo��,J�{��
W�v9V�[>��C�� ���s�<�o/��´�l��t���xye�4��<�/ֹ!OKf�|y��S諘��,]s����oc��g�.*3��eT�-:�����|𴋥tA�A1u�풣����C춳�\=%����J����)ߵ�<6�7�)�}$5�h/�fO�nk�MTs����ODG��<�Z��,zB��3(���C��$��R�L���O&B>�2�<�K)�,����ON{�"4,�7Awr��s�iB��W���Pv�Bvm<��=�rv���I稥/��zi�0�̻44�#曚��́�饍,0ܽ���ىAs i���k\��k���oU���xO��	��&�Ƭ�DK�Ro�_o|��$܀=��O>S~���Co���>?	1I�Z���.i{e���Ou�E���z� ���:����n��1ֵ%����:�u�Q��tE
��+�+�RL͌e�����
~���&[��s�=�<���f�/�7�����an�a�#���~1���rK�����V�{��9��}���W��\G�d��9������c�K�ߩ��?�{����W�,���`a��.�G�Q.�W������82�0!����02�����aR�������C~�;fF�me8�����&n#���U��}�������5�N�l���."�?N���hO�U1��M�e�ǲ3��4?NFZU���M�?C�"i�::�Ȭ�b�Г�_��.�c`N�~��@tAK�q�Hـ�9�܎�����R��M��,,��͸��ܱ�?N����(Sڨ�]��֓X��E�y����j9��7_�Eq��|mAN���s��%��&�˃6���o�{��܆M���"�&��Q9z�%�:�v�mK�{���Z1�Ojg�"�ňFʱL33h&+�P&{����g�,+��g��؝Q��Q�g��LB���z�!������S��ZNV�����h� 	ƕ�-[�����t����-�ϲ+�*���.�H���q��� j�(�s���7�۸v�Δ�:�9CO�c@�j{u��t�l��1X�z������-�?_����˻��o#=�O�	��!Q�^vf���m�OI������O�9�M	K#R	�E::!lǟ�B���tR�~,�T���o2���;�Џ�,d�����.��{'�e~6l&�J;]8��%Y����8�H��x�����j풡�k��&H�)'���rf����>v�ix��T����,�v�Aw6Ƴh+I+���R��K��f���=oϜÖ�]iC1��%M=�H��,��F����^��K���J����q�`��Ԟ����o?�5���#�0�x^�(p�r�9���]�6�ؒ��&Ʃ������r�ߒ�̾|҇/鏯���ue,fRMnP'�g���K46L�x��x�V�����4�¢�\�מīE6qS��>��\l�v���o#���g��WQ�}O��s����/5f2�x���ox-����F��n�}q�4��4�-f��`�xÇ���(��r�g~�
�ٟa��̮���9ڥ��������M�sMo�{:˼*f�����?t
̴׉ڊ�[N���W�;\��i~BbS�l7O�����k�����=��D�H^!���`y"w�f�E7}���B����
���2��v×�z�Ւ���"�kJ�4�R���T�G}oi���kI���y��ԂM-����[�����0�|3����A���E�x�6�&��ȗ��O.=��]�g��y]vԩת~�m*�ΐ����>�?�h�U&���F��>q�w�]Z��W�:�;���XxzIKu�R3U5w�G�VDL���fP�~��Z���{l��WLQӏ6u^�&'6���vW$��G�(��	L�������p�^�2R�#��S^��*��^�vg5:����u8t��js7}���}������KBG�����*-Ά�ÿ|�D,�v	�-y�l��v>4��ͪ��/#A����O&X������"v�λ~��z�kӱ��9j��/�Xz��)�7!:`����ig6��ah��	j~��Ҍ��[^�V�"�g}XxT���G�E�n��j�NLe�YÖ���{q�qoܙ��=I�����F��#�6�ww�Ơ�T8՞H�m��m�(g�ϰ�ҽXW��Y���������>�[Yǵ�	����#<υ����aΝ�n�����(���4�V��\�@10�ß�>���	���u���1	�� P��ԮHS'��#V3Ϙ����m]z��y������ZZ���&���}
�6׏�V\^0��j���K�G��9���+�����V����Y�����#�%��ç64U^��y^P�d�`Si7���C���o����mۄ�9��u���]SS�)o���OV�cfv".������*٨9)̳�Q<7�b�-���E�G*���A�C�+����<r�/�5�obvW�b_�
2I<��9!e�;@M��na��΢��h�'����"��F�i���I�i!���'���8s~Aq�Cn��)�}�oJ8��Fl;}λ����_�"��������2���*{5�;7mҞti��F�c��<'�d����+���Jw�%��<�r���=��|�o�x���Qu*�u��Y��_����-����xM7��^G��=�;�L�[˔t'nD�Hȷ<>��Y۱���!�=�I<;��ۜ���q�xC��Lz��f�W8��
}�'J�Q�"{wo�h�/��r|�ٵ�ǋ�c��w�d��8��ޔ"GU��M�g�U�[2��.횯[��X�����W�����ZN�t�U��"�n��ӂ��^<�$�6�������MjخF�����8{?+\ռ�P�`c$����������=���&o.�����(`DD66�I܈|ϛص�|c�H �Q.F.�譞��zz�6�遍��&��S�BI3
|�s�z���b#e_�a�Wsi�;|�D�6��9��c�ksl�[OFƂ�dUf�ˆ$o�'1u�E��GwK+|W��n�xl�b�~�1����:�б|Oގv���J�ٺ�v�����{;��6�QE6kz�*\���_���F��� Xh���r7ױ���	.�͍�"��Y�tXs��lẑ��*F�,�S�ߋ�+ַ�=�5��)1��H�)L������B}��d��QA����U,"f�J�Z���/5{N܋/Q;?��m��P&�J�d9�L��?"2R�I�uO�Ψ��WI�����o}�������OG�	̗���?�oyxڅ_�;�n�߾���ϳ���1�_|�OFZZ���������3����b�o��}�a�c2�k��%,���(�량K�����Ġ׎�"�W������������0M{њ_L�ʊD��������+�^�����@����_#�<�{S�+/��,,�,S3�����B밖$`
}����$A�σ�A���A����儦` 9��FaP�
`i�e`�geet�,L���������7��OAP� u�+hdD}	
A���q!�/�� ���I��/!�&����u���a~��������_��/������_��/������_��/������_��/������_����g�)b x  