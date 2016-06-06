extern void printi(int);
extern void prints(char *);
extern long long* subtraction(long long* A, long long* B, int lon);
extern void* allocate(int size);
extern void* open_file(char *);

int main(){
	void* file = open_file("plik.txt");
	//int a=5000;
	//void* new = allocate(a);
	//char* tekst = "Wyswietlanie tekstu\nWyswietlanie liczby: ";
	//long long* A = 12;
	//long long* B = 321;
	
	//B = subtraction(A,B,a);
	//prints(tekst);
	//printi(a);
	//prints("\n");
	return 0;
}
