#!perl -w

use strict;
use Test::Simple tests => 5;
use Lingua::RU::Sklon; 

ok(sklon('����� �������� ������������'=>'ROD') eq '������ ��������� �������������', '�����');
ok(sklon('������������ ����� ����������'=>'DAT') eq '������������ ����� ����������', '������������ ����� ����������');
ok(sklon('��� ����� ���������'=>'ROD') eq '��� ����� ���������', '���');
ok(sklon('��������� ������ ����������'=>'TVOR') eq '����������� ������� ������������', '���������');
ok(sklon('������ ���� ����������'=>'PRED') eq '������ ����� �����������', '���� 1');
