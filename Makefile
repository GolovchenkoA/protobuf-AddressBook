# See README.txt.

.PHONY: all java clean

all: java

java:   add_person_java   list_people_java

clean:
	rm -f add_person_cpp list_people_cpp add_person_java list_people_java add_person_python list_people_python
	rm -f javac_middleman AddPerson*.class ListPeople*.class com/example/tutorial/*.class
	rm -f protoc_middleman addressbook.pb.cc addressbook.pb.h addressbook_pb2.py com/example/tutorial/AddressBookProtos.java
	rm -f *.pyc
	rm -f protoc_middleman_go tutorial/*.pb.go add_person_go list_people_go
	rmdir tutorial 2>/dev/null || true
	rmdir com/example/tutorial 2>/dev/null || true
	rmdir com/example 2>/dev/null || true
	rmdir com 2>/dev/null || true

protoc_middleman: addressbook.proto
	protoc $$PROTO_PATH --cpp_out=. --java_out=. --python_out=. addressbook.proto
	@touch protoc_middleman

javac_middleman: AddPerson.java ListPeople.java protoc_middleman
	javac -cp $$CLASSPATH AddPerson.java ListPeople.java com/example/tutorial/AddressBookProtos.java
	@touch javac_middleman

add_person_java: javac_middleman
	@echo "Writing shortcut script add_person_java..."
	@echo '#! /bin/sh' > add_person_java
	@echo 'java -classpath .:$$CLASSPATH AddPerson "$$@"' >> add_person_java
	@chmod +x add_person_java

list_people_java: javac_middleman
	@echo "Writing shortcut script list_people_java..."
	@echo '#! /bin/sh' > list_people_java
	@echo 'java -classpath .:$$CLASSPATH ListPeople "$$@"' >> list_people_java
	@chmod +x list_people_java
