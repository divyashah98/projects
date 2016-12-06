#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#define MAX 10

struct Node {
    char *data;
    int count;
    struct Node* next;
};

struct Node2 {
    char data[30];
    int count;
};

/*Child Process functions*/
void push (struct Node** headRef, char *data) {
    struct Node* first;
    first = (struct Node*)malloc (sizeof (struct Node));
    first->data = (char*)malloc (sizeof (char)*(strlen(data)+1));
    strcpy(first->data, data);
    first->count = 1;
    first->next = *headRef;
    *headRef = first;
}

int findPos (struct Node **headRef, char *data, int count_add) {
  struct Node *current;
  int i = 1;
  current = *headRef;
  if (current == NULL)
    return 1;
  while (current != NULL) {
    int temp = strcmp(data, current->data);
    if (temp >0) {
      current = current->next;
      i++;
    }
    else if (temp <0) {
      return i;
    }
    else if(temp == 0){
      current->count = current->count + count_add;
      return -1;
    }
  }
  return i;
}

void insertN (struct Node **headRef, int pos, char *data, int count) {
    struct Node *current;
    current = *headRef;
    if (pos == 1){
      push (headRef, data);
      current->count = count;
    }
    else {
        struct Node *insert;
        struct Node *previous;
        int i=0;
        insert = (struct Node*)malloc (sizeof(struct Node));
        insert->data = (char*)malloc (sizeof (char)*(strlen(data)+1));
        strcpy(insert->data,data);
        insert->count = count;
        while ((current != NULL) && (i < pos-1)) {
            i++;
            previous = current;
            current = current->next;
        }
        if (current == NULL) {
            previous->next = insert;
            insert->next = NULL;
        }
        else {
            if (strcmp(current->data, insert->data) == 0)
              insert->count = current->count;
            previous->next = insert;
            insert->next = current;
        }
    }

}

void processFile (FILE *fp, struct Node **headRef, int no_words) {
  char char_read[20] = {'\0'};
  int i, pos;
  char tmp = '1';
  long int counter = 0;
  while (tmp != EOF) {
    tmp = fgetc(fp);
    printf("%c",tmp);
    for (i = 0; (tmp != ' ') && (tmp != EOF) && (tmp != '\n'); i++) {
      char_read[i] = tmp;
      int char_num = char_read[i];
      if ((char_num < 48) ||
          ((char_num > 57) && (char_num < 65)) ||
          ((char_num > 90) && (char_num < 97)) ||
          ((char_num > 122)))
        i--;
      else if ((char_num >= 65) &&
               (char_num <= 90))
        char_read[i] = char_read[i] + 32;
      tmp = fgetc(fp);
    }
    char_read[i] = '\0';
    printf(" %s",char_read);
    pos = findPos (headRef, char_read, 1);
    if(pos!=-1)
        insertN (headRef, pos, char_read, 1);
    if(++counter >= no_words && no_words != -1){
        return;
    }
  }
}

void printCountChild (int pipe[2], struct Node *head) {
    struct Node2 *current;
    while(head!=NULL){
    	current = (struct Node2*)malloc (sizeof(struct Node2));
    	strcpy(current->data,head->data);
    	current->count = head->count;
        write(pipe[1], current, sizeof(struct Node2));
        head = head->next;
        free(current);
    }
    current = (struct Node2*)malloc (sizeof(struct Node2));
    current->count = -1;
    strcpy(current->data, "END");
    write(pipe[1], current, sizeof(struct Node2));
    free(current);
    
}



/*Parent Process*/
void printCountParent (FILE *fp, struct Node *head) {
    while (head!=NULL) {
          fprintf(fp, "%s %d\n", head->data, head->count);
          head = head->next;
    }
}


int count_words(FILE *fp){
    char tmp = '1';
    if (fp == NULL)
    {
      printf("Error: '%s'",strerror(errno));
      return 0;
    }
    int counter = 1;
    tmp = fgetc(fp);
    int i = 0;
    int in_word = 0;
    while(tmp!=EOF) {
     if ((tmp < 48) ||
          ((tmp > 57) && (tmp < 65)) ||
          ((tmp > 90) && (tmp < 97)) ||
          ((tmp > 122)))
{
          if(in_word == 0){ //assuming space after every punctuation
              counter++;
          }
          in_word = 1;
      }
      else{
          in_word = 0;
      }
      tmp = fgetc(fp);
    }
    printf("Debug_Count_words\n");
    return counter;

}

void mark_places(int deg, int count, FILE* inp_start[MAX], char filename[20]){
    int no_words = count/deg;
    int rem = count%deg;
    char tmp = '1';
    int counter = 0;
    FILE* fp = fopen(filename,"r");
    inp_start[0] = fopen(filename,"r");
    tmp = fgetc(fp);
    int i = 1;
    int in_word = 0;
    while(tmp!=EOF){
        tmp = fgetc(fp);
        if ((tmp < 48) ||
              ((tmp > 57) && (tmp < 65)) ||
              ((tmp > 90) && (tmp < 97)) ||
              ((tmp > 122))){
              if(in_word == 0){
                counter++;
                if(counter>=no_words){
                    inp_start[i] = fopen(filename, "r");
                    fseek(inp_start[i], ftell(fp), SEEK_SET);
                    counter = 0;
                    i++;
                    if(i >= deg){
                        break;
                    } 
                }
              }
              in_word = 1;
        }
        else{
            in_word = 0;
        }
    }
    if (fp != NULL){
      printf("Closing fp\n");
      fclose(fp);
    }
    
}
int main ( int argc, char *argv[] )
{
    struct Node* head = NULL;
    FILE *inp_txt, *out_count, *out_runtime;
    clock_t curr_time, end_time;
    

    inp_txt = fopen(argv[1], "r");
    int count = count_words(inp_txt);
    printf("\nWord Count : %d %d",count, getpid());
    fflush(stdout);
    if (inp_txt != NULL){
      printf("Closing inp_txt\n");
      fclose(inp_txt);
    }
    
    int deg = atoi(argv[4]);
    FILE *inp_start[deg];
    printf("Debug_before_mark_places");
    mark_places(deg, count, inp_start, argv[1]);
    printf("Debug_after_mark_places");
    fflush(stdout);
    int i, nbytes;
    pid_t pid;
    int fd[deg][2];
    struct Node2* readbuffer;

for(i = 0; i < deg; i++) {
    pipe(fd[i]);
    pid = fork();
    if(pid < 0) {
        printf("Error");
        exit(1);
    } else if (pid == 0) {
        close(fd[i][0]);
        printf("\nProcessing file Started for %d process : %d",i+1, getpid());
        processFile (inp_start[i], &head, i==deg-1?-1:(count/deg)); 
        printf("\nProcessing file ended for %d process",i+1);
        fflush(stdout);
        printf("\nPrinting word count beginning for %d process",i+1);
        printCountChild(fd[i], head);
        printf("\nPrinting word count completed for %d process", i+1);
        fflush(stdout);
        free(inp_start[i]);
        exit(0); 
    } 
}

waitpid(-1,NULL,NULL);
readbuffer = (struct Node2*)(malloc(sizeof(struct Node2)));
readbuffer->count = 0;
FILE* out_txt = fopen(argv[2], "w");
for(i=0; i< deg;i++){
    close(fd[i][1]);
    open(fd[i][0]);
    while(readbuffer->count != -1){
        nbytes = read(fd[i][0], readbuffer,sizeof(struct Node2));
        if(readbuffer == NULL){
            break;
        }
        if(readbuffer->count == -1){
            break;
        }
        printf("\n%s %d",readbuffer->data, readbuffer->count);
        int pos = findPos (&head, readbuffer->data, readbuffer->count);
        if(pos!=-1)
            insertN (&head, pos, readbuffer->data, readbuffer->count);
    }
    readbuffer->count = 0;
    fflush(stdout);
    if(i >=deg ){
         printCountParent(out_txt, head);
         if (out_txt != NULL){  
           printf("Closing out_txt\n");
           fclose(out_txt);
          }
         exit(0);
    }
    close(fd[i][0]);
}

}

