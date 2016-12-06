#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<time.h>


struct Node {
    char *data;
    int count;
    struct Node* next;
};

void push (struct Node** headRef, char *data) { 
    struct Node* first;
    first = malloc (sizeof (struct Node));
    first->data = malloc (sizeof (char));
    strcpy(first->data, data);
    first->next = *headRef;
    *headRef = first;
}

int findPos (struct Node **headRef, char *data) {
  struct Node *current;
  int i = 1;
  current = *headRef;
  if (current == NULL)
    return 1;
  while (current != NULL) {
    strcmp(data, current->data);
    if (strcmp(data, current->data) == 1) {
      current = current->next;
      i++;
    }
    else if (strcmp(data, current->data) == -1) {
      return i;
    }
    else {
      current->count++;
      return i;
    }
  }
  return i;
}

void insertN (struct Node **headRef, int pos, char *data) {
    struct Node *current; 
    current = *headRef;
    if (pos == 1)
      push (headRef, data);
    else {
        struct Node *insert; 
        struct Node *previous; 
        int i=0;
        insert = malloc (sizeof(struct Node));
        insert->data = malloc (sizeof (char));
        strcpy(insert->data,data);
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

void processFile (FILE *fp, struct Node **headRef) {
  char char_read[255] = {'\0'};
  int i, pos;
  char tmp = '1';
  while (tmp != EOF) {
    tmp = fgetc(fp);
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
    pos = findPos (headRef, char_read);
    insertN (headRef, pos, char_read);
  }
}

void printCount (FILE *fp, struct Node *head) {
    char *data, *data_init;
    data = malloc(sizeof(char));
    data_init = malloc(sizeof(char));
    strcpy(data_init, head->data);
    while (head!=NULL) {
        if (strcmp(head->data, data_init) != 0)
          fprintf(fp, "%s %d\n", head->data, head->count+1);
        strcpy(data, head->data);
        while ((strcmp(head->data, data) == 0)) {
          head = head->next;
          if (head==NULL)
            break;
        }
    }
    free(data);
    free(data_init);
}

int main (int argc, char *argv[]) {
    struct Node* head = NULL;
    FILE *inp_txt, *out_count, *out_runtime;
    clock_t curr_time, end_time;

    curr_time = clock();

    inp_txt = fopen(argv[1], "r");
    processFile (inp_txt, &head);
    close(inp_txt);
    
    out_count = fopen(argv[2], "w");
    printCount (out_count, head);
    close(out_count);
    
    end_time = clock();

    double elapsed = (end_time - curr_time)/(double)CLOCKS_PER_SEC;
    out_runtime = fopen(argv[3], "w");
    fprintf(out_runtime, "Total runtime of the program in seconds is %f\n", elapsed);
    close(out_runtime);
    return 0;
}
