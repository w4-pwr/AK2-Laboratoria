#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

extern int *getHeader(char *buffer);
extern void negateImageMMX(char *buffer, int fileLenght);
extern void negateImage(char *buffer, int fileLenght);

void saveFile(char *buffer, int fileLenght, char* name) {
	FILE *file;
	file = fopen(name, "wb");
	fwrite(buffer, fileLenght, 1, file);
	fclose(file);
}

int getLenghtOfFile(char *buffer) {
	FILE *file;
	int fileLenght;
	file = fopen(buffer, "rb");
	fseek(file, 0, SEEK_END);
	fileLenght = ftell(file);
	rewind(file);
	fclose(file);
	return fileLenght;
}

char *readFile(char *src, int fileLenght) {
	FILE *file;
	char *buffer;
	file = fopen(src, "rb");
	buffer = (char *) malloc((fileLenght + 1) * sizeof(char));
	fread(buffer, fileLenght, 1, file);
	fclose(file);
	return buffer;
}

void rotate(char *data, int width, int height) {
	char *tmpBuffer = (char*) malloc(3 * width); //alokujemy pamiec na jeden wiersz
	int lenghtToCopy = 3 * (width) + width % 4; // długość wiersza do skopiowania z uwzględnieniem bitów dopełnienia
	int i, offset_new, offset_old;
	for(i = 0; i < height/2; i++) {
		offset_old = (lenghtToCopy * (i + 1)); // offset określający wiersz do skopiowania
		memcpy(tmpBuffer, data + offset_old, lenghtToCopy); //stara linijka do tmpBuffer

		offset_new = ((height - i) * lenghtToCopy); // offset określający wiersz w którym ma pojawić się nowy ciag pikseli
		memcpy(data + offset_old, data + offset_new, lenghtToCopy); //zastąpienie "dolnego wiersza" "górnym wierszem"

		memcpy(data + offset_new, tmpBuffer, lenghtToCopy); //skopiowanie wiersza z bufora tymczasowwego do nowego miejsca
	}
}

void testMMX(char *data, int fileLenght){
int i;
for(i = 0; i < 1; i++){
    		negateImageMMX(data, fileLenght);
	}
}

void testWithoutMMX(char *data, int fileLenght){
int i;
for(i = 0; i < 1; i++){
    		negateImage(data, fileLenght);
	}
}

int main() {
	char *processedImageName = "processed.bmp";
	char *fileName = "test.bmp";

	int fileLenght = getLenghtOfFile(fileName);
	char *buffer = readFile(fileName, fileLenght);
	int *header = getHeader(buffer);

	printf("Szerokosc: %d\n", header[0]);
	printf("Wysokosc: %d\n", header[1]);
	printf("Poczatek danych: %d\n", header[2]);
	printf("Wielkosc pliku: %d bajtów\n", header[3]);
	printf("Bitów na pixel: %d-bits\n", header[4]);
	printf("Typ kompresji: %d\n", header[5]);
	printf("Sygnatura: %x\n", header[6]);
	char *data = buffer + header[2];

	remove(processedImageName);
    	//rotate(data, header[0], header[1]);
	//printf("%d", data[0]);
	testMMX(data, fileLenght);
	testWithoutMMX(data, fileLenght);
	saveFile(buffer, fileLenght, processedImageName);

	return 0;
}
