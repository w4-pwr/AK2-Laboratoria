
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
//extern char* decodeJpeg(char* buffer);
//extern char* encodeJpeg(char* buffer);


extern int* getBitmapInfo(char* buffer);
extern void grayScale(char* buffer, int len);
extern void grayScaleMmx(char* buffer, int len);
extern int negativeMmx(char* buffer, int len);
extern int changeBrightness(char* buffer, int len, int brightness);
extern int changeBrightnessMmx(char* buffer, int len, int brightness);
extern void rotate(char* in, char* out, int* info, double radians);


//extern void mirrorHorizontal(char* buffer, int h, int w);
//extern void mirrorVertical(char* buffer, int h, int w);
//extern void mirrorHorizontalMmx(char* buffer, int h, int w);
//extern void mirrorVerticalMmx(char* buffer, int h, int w);

//extern void rotate(char* buffer, int h, int w);
//extern void rotateMmx(char* buffer, int h, int w);


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
	
	//int x = 0;
	//negativeMmx(data, dataSize);
	
	
	//int dataSize = (len - info[3] + 1) * sizeof(char);
	
	char *buf2 = (char *) malloc(dataSize);
	rotate(data, buf2, info, 0.2);
	memcpy(data, buf2, dataSize);
	free(buf2);
	
	//printf("%X, %X, %d", info[0], info[1], x);
	saveFile(buffer, len, "out.bmp");
	
	
	
	
	
	
	
	return 0;
}
