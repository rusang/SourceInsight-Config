/*
以下是自编，参考上面以及SourceInsight中的chm帮助文档；

有缺点：（1）移动箭头也会记录到历史操作步骤，应该能够避免这些操作被记录；（2）函数没有整理，有冗余；

*/
//2、删除键——SuperDelete.em


macro SuperDelete()
{
    hwnd = GetCurrentWnd();
    hbuf = GetCurrentBuf();

    if (hbuf == 0)
        stop;   // empty buffer

    // get current cursor postion
    ipos = GetWndSelIchFirst(hwnd);

    // get current line number
    ln = GetBufLnCur(hbuf);

    if ((GetBufSelText(hbuf) != "") || (GetWndSelLnFirst(hwnd) != GetWndSelLnLast(hwnd))) {
        // sth. was selected, del selection
        SetBufSelText(hbuf, " "); // stupid & buggy sourceinsight :(
        // del the " "
        SuperDelete(1);
        stop;
    }

    // copy current line
    text = GetBufLine(hbuf, ln);

    // get string length
    len = strlen(text);
       
    if (ipos == len || len == 0) {
totalLn = GetBufLineCount (hbuf);
lastText = GetBufLine(hBuf, totalLn-1);
lastLen = strlen(lastText);

        if (ipos == lastLen)// end of file
   stop;

        ln = ln + 1;    // do not use "ln--" for compatibility with older versions 
        nextline = GetBufLine(hbuf, ln);
        nextlen = strlen(nextline);
        // combine two lines
        text = cat(text, nextline);
        // del two lines
        DelBufLine(hbuf, ln-1);
        DelBufLine(hbuf, ln-1);
        // insert the combined one
        InsBufLine(hbuf, ln-1, text);
        // set the cursor position
        SetBufIns(hbuf, ln-1, len);
        stop;
    }

    num = 1; // del one char
    if (ipos > 0) {
        // process Chinese character
        i = ipos;
        count = 0;
        while (AsciiFromChar(text[i-1]) >= 160) {
            i = i - 1;
            count = count + 1;
            if (i == 0)
                break;
        }
        if (count > 0) {
            // I think it might be a two-byte character
            num = 2;
            // This idiot does not support mod and bitwise operators
            if (((count / 2 * 2 != count) || count == 0) && (ipos < len-1)) 
                ipos = ipos + 1;    // adjust cursor position
        }

// keeping safe
if (ipos - num < 0)
            num = ipos; 
    }
    else {
i = ipos;
count = 0;
while(AsciiFromChar(text[i]) >= 160) {
     i = i + 1;
     count = count + 1;
     if(i == len-1)
   break;
}

if(count > 0) {
     num = 2;
}
    } 
    
    text = cat(strmid(text, 0, ipos), strmid(text, ipos+num, len));
    DelBufLine(hbuf, ln);
    InsBufLine(hbuf, ln, text);
    SetBufIns(hbuf, ln, ipos);
    stop;
}

//3、左移键——SuperCursorLeft.em

macro IsComplexCharacter() 
{
hwnd = GetCurrentWnd();
hbuf = GetCurrentBuf();

if (hbuf == 0) 
   return 0;


//当前位置
pos = GetWndSelIchFirst(hwnd);

//当前行数
ln = GetBufLnCur(hbuf);

//得到当前行
text = GetBufLine(hbuf, ln);

//得到当前行长度
//得到
len = strlen(text);

//从头计算汉字字符的个数
if(pos > 0) 
{
   i=pos;
   count=0;
   while(AsciiFromChar(text[i-1]) >= 160)
   { 
    i = i - 1;
    count = count+1;
    if(i == 0) 
     break;
   }

   if((count/2)*2==count|| count==0)
    return 0;
   else
    return 1;
}

return 0;
}

macro moveleft() 
{
hwnd = GetCurrentWnd();
hbuf = GetCurrentBuf();
if (hbuf == 0)
        stop;   // empty buffer
        
ln = GetBufLnCur(hbuf); 
ipos = GetWndSelIchFirst(hwnd);

if(GetBufSelText(hbuf) != "" || (ipos == 0 && ln == 0))   // 第0行或者是选中文字,则不移动
{
   SetBufIns(hbuf, ln, ipos); 
   stop;
}

if(ipos == 0) 
{
   preLine = GetBufLine(hbuf, ln-1);
   SetBufIns(hBuf, ln-1, strlen(preLine)-1);
}
else 
{
   SetBufIns(hBuf, ln, ipos-1); 
}
}



macro SuperCursorLeft()
{
moveleft(); 
if(IsComplexCharacter())
   moveleft();
}

//4、右移键——SuperCursorRight.em

macro moveRight() 
{
hwnd = GetCurrentWnd();
hbuf = GetCurrentBuf();
if (hbuf == 0)
        stop;   // empty buffer
ln = GetBufLnCur(hbuf); 
ipos = GetWndSelIchFirst(hwnd);
totalLn = GetBufLineCount(hbuf); 
text = GetBufLine(hbuf, ln);

if(GetBufSelText(hbuf) != "")   //选中文字
{
   ipos = GetWndSelIchLim(hwnd);
   ln = GetWndSelLnLast(hwnd);
   SetBufIns(hbuf, ln, ipos); 
   stop;
}

if(ipos == strlen(text)-1 && ln == totalLn-1) // 末行 
   stop;     

if(ipos == strlen(text)) 
{ 
   SetBufIns(hBuf, ln+1, 0);
}
else 
{
   SetBufIns(hBuf, ln, ipos+1); 
}
}

macro SuperCursorRight()
{
moveRight(); 
if(IsComplexCharacter()) // defined in SuperCursorLeft.em
   moveRight();
}

//5、shift+右移键——ShiftCursorRight.em

macro IsShiftRightComplexCharacter() 
{
hwnd = GetCurrentWnd();
hbuf = GetCurrentBuf();

if (hbuf == 0) 
   return 0;

selRec = GetWndSel(hwnd); 
pos = selRec.ichLim; 
ln = selRec.lnLast; 
text = GetBufLine(hbuf, ln); 
len = strlen(text);

if(len == 0 || len < pos)
   return 1;

//Msg("@len@;@pos@;"); 
if(pos > 0) 
{
   i=pos;
   count=0; 
   while(AsciiFromChar(text[i-1]) >= 160)
   { 
    i = i - 1;
    count = count+1;   
    if(i == 0) 
     break;    
   }

   if((count/2)*2==count|| count==0)
    return 0;
   else
    return 1;
}

return 0;
}

macro shiftMoveRight() 
{
hwnd = GetCurrentWnd();
hbuf = GetCurrentBuf();
if (hbuf == 0)
        stop;   
        
ln = GetBufLnCur(hbuf); 
ipos = GetWndSelIchFirst(hwnd);
totalLn = GetBufLineCount(hbuf); 
text = GetBufLine(hbuf, ln); 
selRec = GetWndSel(hwnd);  

curLen = GetBufLineLength(hbuf, selRec.lnLast); 
if(selRec.ichLim == curLen+1 || curLen == 0)
{ 
   if(selRec.lnLast == totalLn -1)
    stop;

   selRec.lnLast = selRec.lnLast + 1; 
   selRec.ichLim = 1;
   SetWndSel(hwnd, selRec);
   if(IsShiftRightComplexCharacter())
    shiftMoveRight();
   stop;
}

selRec.ichLim = selRec.ichLim+1;
SetWndSel(hwnd, selRec);
}

macro SuperShiftCursorRight()
{        
if(IsComplexCharacter())
   SuperCursorRight();

shiftMoveRight(); 
if(IsShiftRightComplexCharacter())
   shiftMoveRight();
}

//6、shift+左移键——ShiftCursorLeft.em

macro IsShiftLeftComplexCharacter() 
{
hwnd = GetCurrentWnd();
hbuf = GetCurrentBuf();

if (hbuf == 0) 
   return 0;

selRec = GetWndSel(hwnd); 
pos = selRec.ichFirst; 
ln = selRec.lnFirst; 
text = GetBufLine(hbuf, ln); 
len = strlen(text);

if(len == 0 || len < pos)
   return 1;

//Msg("@len@;@pos@;"); 
if(pos > 0) 
{
   i=pos;
   count=0; 
   while(AsciiFromChar(text[i-1]) >= 160)
   { 
    i = i - 1;
    count = count+1;   
    if(i == 0) 
     break;    
   }

   if((count/2)*2==count|| count==0)
    return 0;
   else
    return 1;
}

return 0;
}

macro shiftMoveLeft() 
{
hwnd = GetCurrentWnd();
hbuf = GetCurrentBuf();
if (hbuf == 0)
        stop;   
        
ln = GetBufLnCur(hbuf); 
ipos = GetWndSelIchFirst(hwnd);
totalLn = GetBufLineCount(hbuf); 
text = GetBufLine(hbuf, ln); 
selRec = GetWndSel(hwnd);  

//curLen = GetBufLineLength(hbuf, selRec.lnFirst);
//Msg("@curLen@;@selRec@");
if(selRec.ichFirst == 0)
{ 
   if(selRec.lnFirst == 0)
    stop; 

   selRec.lnFirst = selRec.lnFirst - 1;
   selRec.ichFirst = GetBufLineLength(hbuf, selRec.lnFirst)-1;
   SetWndSel(hwnd, selRec);
   if(IsShiftLeftComplexCharacter())
    shiftMoveLeft();
   stop;
}

selRec.ichFirst = selRec.ichFirst-1;
SetWndSel(hwnd, selRec);
}

macro SuperShiftCursorLeft()
{
if(IsComplexCharacter())
   SuperCursorLeft();

shiftMoveLeft(); 
if(IsShiftLeftComplexCharacter())
   shiftMoveLeft();
}

#ifdef __cplusplus
#if __cplusplus
}
#endif
#endif /* __cplusplus */
