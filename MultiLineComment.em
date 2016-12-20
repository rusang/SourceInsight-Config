//以下是实现多行注释的宏代码（在别的网站copy过来的，经过测试，还是很好用的）：

macro MultiLineComment()

{

    hwnd = GetCurrentWnd()

    selection = GetWndSel(hwnd)

    LnFirst =GetWndSelLnFirst(hwnd)      //取首行行号

    LnLast =GetWndSelLnLast(hwnd)      //取末行行号

    hbuf = GetCurrentBuf()

 

    if(GetBufLine(hbuf, 0) =="//magic-number:tph85666031"){

        stop

    }

 

    Ln = Lnfirst

    buf = GetBufLine(hbuf, Ln)

    len = strlen(buf)

 

    while(Ln <= Lnlast) {

        buf = GetBufLine(hbuf, Ln)  //取Ln对应的行

        if(buf ==""){                   //跳过空行

            Ln = Ln + 1

            continue

        }

 

        if(StrMid(buf, 0, 1) == "/"){       //需要取消注释,防止只有单字符的行

            if(StrMid(buf, 1, 2) == "/"){

                PutBufLine(hbuf, Ln, StrMid(buf, 2, Strlen(buf)))

            }

        }

 

        if(StrMid(buf,0,1) !="/"){          //需要添加注释

            PutBufLine(hbuf, Ln, Cat("//", buf))

        }

        Ln = Ln + 1

    }

 

    SetWndSel(hwnd, selection)

}


//将上面的代码另存为xxx.em文件，打开source insight，将该文件添加到工程中，然后在Options->KeyAssignments中你就可以看到这个宏了，宏的名字是MultiLineComments，然后我们为它分配快捷键“Ctrl + /”，然后就可以了。

//这里还有一份添加“#ifdef 0”和“#endif”的宏代码：

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

            sel.lnFirst = sel.lnFirst – 1

            sel.lnLast = sel.lnLast – 1

    } else {

            InsBufLine(hbuf, lnFirst, "#if 0")

            InsBufLine(hbuf, lnLast+2, "#endif")

            sel.lnFirst = sel.lnFirst + 1

            sel.lnLast = sel.lnLast + 1

    }

 

    SetWndSel( hwnd, sel )

}


//这份宏的代码可以把光标显示的行注释掉：

macro CommentSingleLine()

{

    hbuf = GetCurrentBuf()

    ln = GetBufLnCur(hbuf)

str = GetBufLine (hbuf, ln)

    str = cat("/*",str)

    str = cat(str,"*/")

    PutBufLine (hbuf, ln, str)

}

//将一行中鼠标选中部分注释掉：

macro CommentSelStr()

{

    hbuf = GetCurrentBuf()

    ln = GetBufLnCur(hbuf)

    str = GetBufSelText(hbuf)

    str = cat("/*",str)

    str = cat(str,"*/")

    SetBufSelText (hbuf, str)

}


