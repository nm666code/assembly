.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword
INCLUDE test.inc

.data
	msg1 BYTE "�п�J�Ʀr(0~22):",0
	inval DWORD ?
	msg2 BYTE "�Ʀr�Ӥj�A�Э��s��J......:",0

.code

main PROC
L0:
	mov edx,OFFSET msg1
	call WriteString
	call ReadDec
	call Crlf
	mov inval,eax
	.IF eax > 22
		mov edx,OFFSET msg2
		call WriteString
		call Crlf
		jmp L0
	.ENDIF

	mov ebx,0
	.REPEAT
		INVOKE BinomialCoefficient,ebx
		inc ebx
	.UNTIL ebx > inval
	
	call Crlf
	call WaitMsg
	
	INVOKE ExitProcess, 0
main ENDP

END main

main PROC
