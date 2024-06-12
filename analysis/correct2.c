#include "lambdalib.h"
#include <math.h>


#define SELF struct Pet *self
typedef struct Pet
{
  char *name;
  char *species;
  int age;

  void (*newPet) (SELF, char *n, char *s, int a);
  void (*printPet) (SELF);
} Pet;

void
newPet (SELF, char *n, char *s, int a)
{
  self->name = n;
  self->species = s;
  if (a < 0)
    {
      writeStr ("Invalid age!\n");
      exit (0);
    }
  self->age = a;
}


void
printPet (SELF)
{
  writeStr (self->name);
  writeStr ("\t\t");
  writeInteger (self->age);
  writeStr ("\t");
  writeStr (self->species);
  writeStr ("\n");
}


const Pet ctor_Pet = {.newPet = newPet,.printPet = printPet };

#undef SELF


#define SELF struct Person *self
typedef struct Person
{
  char *name;
  char *surname;
  int age;
  int gender;
  Pet pet;

  void (*newPerson) (SELF, char *n, char *s, int a, int g, Pet p);
  void (*printPerson) (SELF);
} Person;

void
newPerson (SELF, char *n, char *s, int a, int g, Pet p)
{
  self->name = n;
  self->surname = s;
  if (a < 0)
    {
      writeStr ("Invalid age!\n");
      exit (0);
    }
  self->age = a;
  self->gender = g;
  self->pet = p;
}


void
printPerson (SELF)
{
  writeStr (self->name);
  writeStr ("\t");
  writeStr (self->surname);
  writeStr ("\t");
  writeInteger (self->age);
  writeStr ("\t");
  if (self->gender)
    {
      writeStr ("Male\t");
    }
  else
    {
      writeStr ("Female\t");
    }
  writeStr ("\t");
  writeStr ("\n");
}


const Person ctor_Person = {.newPerson = newPerson,.printPerson =
    printPerson };
#undef SELF

int
main ()
{

  Person person1 = ctor_Person;

  Person person2 = ctor_Person;

  Person person3 = ctor_Person;

  Person person4 = ctor_Person;

  Person person5 = ctor_Person;

  Pet pet1 = ctor_Pet;

  Pet pet2 = ctor_Pet;

  Pet pet3 = ctor_Pet;

  Pet pet4 = ctor_Pet;
  pet1.newPet (&pet1, "Max", "Dog", 1);
  pet2.newPet (&pet2, "Bella", "Cat", 3);
  pet3.newPet (&pet3, "Charlie", "Parrot", 2);
  pet4.newPet (&pet4, "Daisy", "Rabbit", 5);
  person1.newPerson (&person1, "Charilaos", "Kapelonis", 22, 1, pet1);
  person2.newPerson (&person2, "Argiroula", "Georgiou", 21, 0, pet1);
  person3.newPerson (&person3, "Anastasia", "Sotiropoulou", 26, 0, pet2);
  person4.newPerson (&person4, "Elenitsa", "Koukourou", 22, 0, pet3);
  person5.newPerson (&person5, "Eleftherios", "Petridis", 35, 1, pet4);
  writeStr ("Name\t\tSurname\t\tAge\tGender\n");
  writeStr ("______________________________________________________\n");
  person1.printPerson (&person1);
  person2.printPerson (&person2);
  person3.printPerson (&person3);
  person4.printPerson (&person4);
  person5.printPerson (&person5);
  writeStr ("\n\n\n");
  writeStr ("Name\t\tAge\tSpecies\n");
  writeStr ("____________________________________\n");
  pet1.printPet (&pet1);
  pet2.printPet (&pet2);
  pet3.printPet (&pet3);
  pet4.printPet (&pet4);
}
