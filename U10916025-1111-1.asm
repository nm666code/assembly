ExitProcess proto
ReadInt64   proto
WriteInt64  proto
WriteString proto
Crlf        proto
Randomize   proto
RandomRange proto

.data
buffer1		BYTE "我是U10916025陳冠諭!", 0
buffer2		BYTE "請輸入Random Number的數量(少於50):", 0
buffer3		BYTE "請輸入Random Number的lowerbound:", 0
buffer4		BYTE "請輸入Random Number的upperbound:", 0
buffer5		BYTE ",", 0
buffer6		BYTE " ", 0
randArray   QWORD 51 DUP(0) 
targetArray QWORD 51 DUP(0)
itemcount   QWORD ?
lowerbound  QWORD ?
upperbound  QWORD ?

.code
main proc
	mov  RDX, OFFSET buffer1
	call WriteString
	call Crlf
	mov  RDX, OFFSET buffer2
	call WriteString
	call ReadInt64
	mov  itemcount, RAX
	call Crlf
	mov  RDX, OFFSET buffer3
	call WriteString
	call ReadInt64
	mov  lowerbound, RAX
	call Crlf
	mov  RDX, OFFSET buffer4
	call WriteString
	call ReadInt64
	mov  upperbound, RAX
	call Crlf

	call Randomize
	mov RCX, itemcount
	mov esi, 0
L1:
	mov RBX, lowerbound
	mov RAX, upperbound
	call BetterRandomRange
	mov randArray[RSI], RAX
	add RSI, TYPE randArray
	loop L1

	mov RSI, OFFSET randArray
	mov RCX, itemcount
	call WriteIntegerArray

	call ExitProcess
main endp

BetterRandomRange PROC
	sub RAX, RBX
	call RandomRange
	add RAX, RBX
	ret
BetterRandomRange ENDP

WriteIntegerArray PROC uses RSI RCX RAX
WIA:
	mov RAX,[RSI]
	call WriteInt64
	mov RDX, OFFSET buffer5
	call WriteString
	mov RDX, OFFSET buffer6
	call WriteString
	add RSI, 8
	loop WIA
	ret
WriteIntegerArray ENDP
end