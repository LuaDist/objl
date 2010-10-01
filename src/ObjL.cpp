#include <stdlib.h>
#include <string>
using namespace ::std;

int main(int argc, char** argv) {
	string command="lua -l ObjL";
	int i;
	for (i=1; i<argc; i++) {
		command+=string(" ")+string(argv[i]);
	}
	system(command.c_str());
	return 0;
}
