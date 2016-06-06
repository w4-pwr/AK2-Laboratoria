#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int* getBitmapInfo(char* buffer);
extern void grayScale(char* buffer, int len);
extern void grayScaleMmx(char* buffer, int len);
extern int negativeMmx(char* buffer, int len);
extern void changeBrightness(char* buffer, int len, int brightness);
extern void changeBrightnessMmx(char* buffer, int len, int brightness);
extern void rotate(char* in, char* out, int* info, double radians);

extern void changeContrast(char* buffer, int len, int contrast);
extern void changeContrastMmx(char* buffer, int len, int contrast);

char* getBitmapContent(char* buffer, int* info) {
	return buffer + info[2];
}

void saveFile(char *buffer, int len, char* name) {
	FILE *file;

	file = fopen(name, "wb");
	if(file != NULL) {
		fwrite(buffer, len, 1, file);
		fclose(file);
	} else {
		printf("Brak pliku");
	}
}

int getLen(char* src) {
	FILE *file;
	int filelen;


	file = fopen(src, "rb");
	if(file != NULL) {
		fseek(file, 0, SEEK_END);
		filelen = ftell(file);
		rewind(file);
	
		fclose(file);
	} else {
		printf("Brak pliku");
	}
	
	return filelen;
}
//odczyt pliku skopiowany z internetu 
char *readFile(char* src, int len) {
    FILE *file;
	char *buffer;
	
	buffer = (char *) malloc((len + 1) * sizeof(char)); //wraz z końcem pliku
	file = fopen(src, "rb");
	if(file != NULL) {
		fread(buffer, len, 1, file);
		fclose(file);
	} else {
		printf("Brak pliku");
	}
	return buffer;
}

main() {
	char *path = "test.bmp";
	int len = getLen(path);
	char *buffer = readFile(path, len);
	int* info = getBitmapInfo(buffer);
	char *data = getBitmapContent(buffer, info);
	
	int dataSize = (len - info[2] + 1);
    negativeMmx(data, dataSize);
	// changeBrightness(data, dataSize, 50);
	saveFile(buffer, len, "out.bmp");
	return 0;
}
