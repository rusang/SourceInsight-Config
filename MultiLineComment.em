//������ʵ�ֶ���ע�͵ĺ���루�ڱ����վcopy�����ģ��������ԣ����Ǻܺ��õģ���

macro MultiLineComment()

{

    hwnd = GetCurrentWnd()

    selection = GetWndSel(hwnd)

    LnFirst =GetWndSelLnFirst(hwnd)      //ȡ�����к�

    LnLast =GetWndSelLnLast(hwnd)      //ȡĩ���к�

    hbuf = GetCurrentBuf()

 

    if(GetBufLine(hbuf, 0) =="//magic-number:tph85666031"){

        stop

    }

 

    Ln = Lnfirst

    buf = GetBufLine(hbuf, Ln)

    len = strlen(buf)

 

    while(Ln <= Lnlast) {

        buf = GetBufLine(hbuf, Ln)  //ȡLn��Ӧ����

        if(buf ==""){                   //��������

            Ln = Ln + 1

            continue

        }

 

        if(StrMid(buf, 0, 1) == "/"){       //��Ҫȡ��ע��,��ֹֻ�е��ַ�����

            if(StrMid(buf, 1, 2) == "/"){

                PutBufLine(hbuf, Ln, StrMid(buf, 2, Strlen(buf)))

            }

        }

 

        if(StrMid(buf,0,1) !="/"){          //��Ҫ����ע��

            PutBufLine(hbuf, Ln, Cat("//", buf))

        }

        Ln = Ln + 1

    }

 

    SetWndSel(hwnd, selection)

}


//������Ĵ�������Ϊxxx.em�ļ�����source insight�������ļ����ӵ������У�Ȼ����Options->KeyAssignments����Ϳ��Կ���������ˣ����������MultiLineComments��Ȼ������Ϊ�������ݼ���Ctrl + /����Ȼ��Ϳ����ˡ�

//���ﻹ��һ�����ӡ�#ifdef 0���͡�#endif���ĺ���룺

macro AddMacroComment()

{

    hwnd=GetCurrentWnd()

    sel=GetWndSel(hwnd)

    lnFirst=GetWndSelLnFirst(hwnd)

    lnLast=GetWndSelLnLast(hwnd)

    hbuf=GetCurrentBuf()

    if (LnFirst == 0) {

            szIfStart = ""

    } else {

            szIfStart = GetBufLine(hbuf, LnFirst-1)

    }

    szIfEnd = GetBufLine(hbuf, lnLast+1)

    if (szIfStart == "#if 0" && szIfEnd =="#endif") {

            DelBufLine(hbuf, lnLast+1)

            DelBufLine(hbuf, lnFirst-1)

            sel.lnFirst = sel.lnFirst �C 1

            sel.lnLast = sel.lnLast �C 1

    } else {

            InsBufLine(hbuf, lnFirst, "#if 0")

            InsBufLine(hbuf, lnLast+2, "#endif")

            sel.lnFirst = sel.lnFirst + 1

            sel.lnLast = sel.lnLast + 1

    }

 

    SetWndSel( hwnd, sel )

}


//��ݺ�Ĵ�����԰ѹ����ʾ����ע�͵���

macro CommentSingleLine()

{

    hbuf = GetCurrentBuf()

    ln = GetBufLnCur(hbuf)

str = GetBufLine (hbuf, ln)

    str = cat("/*",str)

    str = cat(str,"*/")

    PutBufLine (hbuf, ln, str)

}

//��һ�������ѡ�в���ע�͵���

macro CommentSelStr()

{

    hbuf = GetCurrentBuf()

    ln = GetBufLnCur(hbuf)

    str = GetBufSelText(hbuf)

    str = cat("/*",str)

    str = cat(str,"*/")

    SetBufSelText (hbuf, str)

}

