do printa w gdb
$ print /f $rax (dolar)
FORMAT: he(x), (d)ecimal, (u)nsigned, (o)ctal, (t)wo, (c)haracter ascii, (f)loat

examine wypisuje zawartosc spod adresu
$ x /()()()
$ x /i $pc
1. ilosc (ile takich fragmentow chcemy wyspisac)
2. co chemy wypisasc (SLOWA)
3. w jakim formacie (FORMAT)

SLOWA: (b)yte, (h)alfword, (w)ord, (g)iant, (s)tring, 

display tworzy liste wartosci ktora bedzie wyswietlac przy kazdym 
$ display /i $pc
$ display /x $rax
$ stepi 
$ display /undisplay 
$ x /8gh $rsp

PATH = /bin : /usr/bin itd
export A=home
echo $PATH // zobaczyc

$x /s 0x07..... #wyswietla zawartosc tego co jest pod tym adresem na stosie

adres na adres
$ x /s *((void**)($rsp+8))

.global .text .data .ascii 
.byte 2, 4 ,8 (przekoduje na 8bitów)
.word
.long (32 bity)
.quad (4 wordy, 64bity) 
.repr powtarza dyrektywę wewnątrz, powtarza n'razy 
example
.repr 8
	.byte 2
.endr

to to samo co .byte 2, 2, 2, 2, 2, 2, 2, 2, 2

xchg A, B
movz #pozwala przenoscic z mniejszego operandu do wiekszego, gora jest uzupelniana zerami

mov %rax, %rbx 
movb $1, (buf)

stos
push A #stos jest podbijany o 8bitów
pop A

pushf #push flag
popf #pop flag

żeby wyłuskać dane z buf (nasza etykieta)
offset (baza, licznik, skalar)  # kazy element moze byc pominiety oprocz bazy
offset + baza + (licznik * skalar) # jak pominiemy skalar to domyslnie chyba jest 8
#korzysta sie z tego do wyciagania danych z petli
mov 8(%rsp, %rcx, 8), %r8

lea << ewaluuje składnie

lea (buf), %r8 == mov $buf, %r8


memorymap
$ man mmap
$ mmap(addr, size, prot, nmap, fd, offset)
       NULL, 4096,     ,
       
       size muzy byc wielokrostnoiscia strony, 4096 (wielokrotonosc strony) 
       prot uprawnienia, do konkretnego zamapowania 
       		PROT_NONE   0x0
       		PROT_READ   0x1
       		PROT_WRITE  0x2
       		PROT_EXEC   0x4
       	nmap map_shared, map_provate, map_anonymous(niezwiazane z zadnym plikiem, zykly przycial pamieci)
       	fd wiadomo
       	offset stale rpzesuniecie w programie (przewaznie 0)
       	
       	numery bitowe tych plikow mamy w pliku /usr/include/bits/nman
      
uni std (9 i 11) 	
munmap
