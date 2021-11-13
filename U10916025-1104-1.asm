INCLUDE Irvine32.inc

.data

str1 BYTE "Please input the first n values of the Padovan number sequence(n =< 81): ",0
str2 BYTE "The first n values of the Padovan number sequence are: ",0
padArray DWORD 94 DUP(0)
num DWORD 1
n1 DWORD 1
n2 DWORD 1
n3 DWORD 1

.code
main PROC

	mov edx,OFFSET str1
	call WriteString
	call crlf

	call ReadInt
	mov num,eax

	mov edx,OFFSET str2
	call WriteString
	call crlf

	mov ecx,num
	dec ecx
	mov eax,n1
	mov padArray,eax
	mov esi,TYPE padArray
L1:
	mov eax,n2
	mov padArray[esi],eax
	mov eax,n1
	add eax,n2
	mov ebx,n2
	mov n1,ebx
	mov ebx,n3
	mov n2,ebx
	mov n3,eax
	add esi,TYPE padArray
	loop L1
	
	mov ecx,num
	mov esi,0
L2:
	mov eax,padArray[esi]
	call WriteDec
	call crlf
	add esi,TYPE padArray
	loop L2
	exit
main ENDP
END main