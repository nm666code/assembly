.386
.model flat, stdcall
.stack 4096
ExitProcess proto, dwExitCode:dword
INCLUDE Irvine32.inc
.data
	buffer1  BYTE "我是U10916025陳冠諭!", 0
	buffer2  BYTE "請輸入(1)hamming code generate (2)Hamming Code Verification (3)Quit: ", 0
	buffer3  BYTE "invalid input, please input again!", 0
	buffer4  BYTE "請在下一行輸入欲編碼的binaray Data String(2~前57位元)............. ", 0
	buffer5  BYTE "錯誤位元的位置在", 0
	buffer6  BYTE "請在下一行輸入與處理的Hamming Code Binary String(5~前63位元)...........", 0
	buffer7  BYTE "完全正確..........",0
	CodeArray BYTE 64 DUP(0)
	CodeLength DWORD ?
	DataArray BYTE 58 DUP(0)
	DataLength DWORD ?
	HCLength DWORD ?
	choice BYTE ?
	ChoiceTable BYTE '1'
				DWORD GenerateHamming
	EntrySize = ($ - ChoiceTable)
				BYTE '2'
				DWORD VerifyHamming
	NumberOfEntries = ($ - ChoiceTable) / EntrySize


.code
main proc

L0:
	call Clrscr
	mov edx,OFFSET buffer1
	call WriteString
	call Crlf
	mov edx,OFFSET buffer2
	call WriteString
	call ReadChar
	mov choice,al
	call Crlf

	mov ebx, OFFSET ChoiceTable
	mov ecx,NumberOfEntries

L1:
	cmp al,[ebx]
	jne L2
	call NEAR PTR [ebx+1]
	call WaitMsg
	jmp L0
L2:
	add ebx, EntrySize
	loop L1
L3:
	cmp al,'3'
	je L4
	mov edx,OFFSET buffer3
	call WriteString
	call Crlf
	call WaitMsg
	jmp L0
L4:
	call Crlf
	call WaitMsg
	invoke ExitProcess,0
main endp

VerifyHamming PROC
VH1:
	mov edx, OFFSET buffer6
	call WriteString
	call Crlf
	mov edx,OFFSET CodeArray
	mov ecx, SIZEOF CodeArray
	call ReadString
	mov CodeLength,eax
	call Crlf
	.IF CodeLength<5
		mov edx,OFFSET buffer3
		call WriteString
		call Crlf
		jmp VH1
	.ELSEIF CodeLength <= 7
		mov HcLength,3
	.ELSEIF CodeLength <= 15
		mov HcLength,4
	.ELSEIF CodeLength <= 31
		mov HCLength,5
	.ELSE
		mov HCLength,6
	.ENDIF
	mov esi,0
	.REPEAT
		mov al,CodeArray[esi]
		.IF !(al == 30h || al == 31h)
			.BREAK
		.ENDIF
		inc esi
	.UNTIL esi == CodeLength
	.IF esi != CodeLength
		mov edx, OFFSET buffer3
		call WriteString
		call Crlf
		jmp VH1
	.ENDIF
	mov eax,0
	mov ecx,0
	.REPEAT
		mov bl,CodeArray[ecx]
		inc ecx
		.IF bl==31h
			xor eax,ecx
		.ENDIF
	.UNTIL ecx == CodeLength
	.IF eax == 0
		mov edx,OFFSET buffer7
		call WriteString
	.ELSE
		mov edx,OFFSET buffer5
		call WriteString
		call WriteDec
	.ENDIF
	call Crlf
	ret
VerifyHamming ENDP



GenerateHamming PROC
GH1:
	mov edx,OFFSET buffer4
	call WriteString
	call Crlf
	mov edx,OFFSET DataARray
	mov ecx, SIZEOF DataArray
	call Readstring
	mov DataLength,eax
	call Crlf
	.IF DataLength<2
	mov edx,OFFSET buffer3
	call WriteString
	call Crlf
	jmp GH1
	.ELSEIF DataLength<=4
		mov HCLength,3
	.ELSEIF DataLength<=11
		mov HCLength,4
	.ELSEIF DataLength<=26
		mov HCLength,5
	.ELSE
		mov HCLength,6
	.ENDIF
	mov esi,0
	.REPEAT		
		mov al,DataArray[esi]
		.IF!(al==30h || al == 31h)
			.BREAK
		.ENDIF
		inc esi
	.UNTIL esi == DataLength
	.IF esi != DataLength 
		mov edx,OFFSET buffer3
		call WriteString
		call Crlf
		jmp GH1
	.ENDIF
	mov esi,0
	mov edi,0
	mov CodeArray[edi],30h
	inc edi 
	mov CodeArray[edi],30h
	inc edi
	.REPEAT
		.IF DataArray[esi] == 30h
			mov CodeArray[edi],30h
		.ELSE
			mov CodeArray[edi],31h
		.ENDIF
		inc esi
		inc edi
		.IF edi==3 || edi == 7 || edi== 15 || edi == 31
			mov CodeArray[edi],30h
			inc edi
		.ENDIF
	.UNTIL esi == DataLength
	mov CodeArray[edi],0
	mov eax,DataLength
	add eax,HCLength
	mov CodeLength,eax
	mov eax,0
	mov ecx,0
	.REPEAT
		mov bl,CodeArray[ecx]
		inc ecx
		.IF bl == 31h
			xor eax,ecx
		.ENDIF
	.UNTIL ecx == CodeLength
	call WriteBin
	call Crlf
	mov ecx,0
	.REPEAT
		bt eax,ecx
		pushfd
		inc ecx
		.IF ecx == 1
			popfd
			.IF CARRY?
				mov CodeArray[0],31h
			.ELSE 
				mov CodeArray[0],30h
			.ENDIF
		.ELSEIF ecx == 2
			popfd
			.IF CARRY?
				mov CodeArray[1],31h
			.ELSE
				mov CodeArray[1],30h
			.ENDIF
		.ELSEIF ecx == 3
			popfd
			.IF CARRY?
				mov CodeArray[3],31h
			.ELSE
				mov CodeArray[3],30h
			.ENDIF
		.ELSEIF ecx == 4
			popfd
			.IF CARRY?
				mov CodeArray[7],31h
			.ELSE
				mov CodeArray[7],30h
			.ENDIF
		.ELSEIF ecx == 5
			popfd
			.IF CARRY?
				mov CodeArray[15],31h
			.ELSE
				mov CodeArray[15],30h
			.ENDIF
		.ELSE
			popfd
			.IF CARRY?
				mov CodeArray[31],31h
			.ELSE
				mov CodeArray[31],30h
			.ENDIF
		.ENDIF
	.UNTIL ecx == HCLength
	call PrintHammingArray
	ret
GenerateHamming ENDP

PrintHammingArray PROC
	mov ecx,0
	mov ebx,0
	.REPEAT
		mov al,CodeArray[ecx]
		call WriteChar
		inc ecx
		inc ebx
		.IF ebx == 4
			mov ebx,0
			mov al,' '
			call WriteChar
		.ENDIF
	.UNTIL ecx == CodeLength
	call Crlf
	ret
PrintHammingArray ENDP
end main

