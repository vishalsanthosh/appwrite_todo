import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

class Appwriteservice {
  late Client client;

   late Databases databases;

   static const endPoint= "https://cloud.appwrite.io/v1";
   static const projectid= "6736e595000f8c08d4fe";
   static const databaseid="6736e636002afcf0746c";
   static const collectionid="6736e68c0005143b6659";

   AppwriteService(){
    client=Client();
    client.setEndpoint(endPoint);
    client.setProject(projectid);
    databases=Databases(client);
   }
   Future<List<Document>>getTasks()async{
   try{
    final result=await databases.listDocuments(databaseId: databaseid, collectionId: collectionid);
    return result.documents;
   }
   catch(e){
    print("error Loading Task:$e ");
    rethrow;
   }
   }
   Future<Document> addTask(String title)async{
    try{
      final documentId=ID.unique();
      final result =await databases.createDocument(databaseId: databaseid, collectionId: collectionid, documentId: documentId,
       data: {
        "Task":title,
        "Completed":false,

       });
       return result;   
    }
    catch(e){
      print("Error creating Task:$e");
      rethrow;
    }
   }
   Future<Document>updateTaskStatus(String documentId,bool completed)async{
    try{
      final result=await databases.updateDocument(databaseId: databaseid, collectionId: collectionid, documentId: documentId,
      data: {"Completed":completed}
      );
     return result;

    }
    catch(e){
      print("Error Updating Task:$e");
      rethrow;
    }
   }
   Future<void>deleteTask(String documentId)async{
    try{
      await databases.deleteDocument(databaseId: databaseid, collectionId: collectionid, documentId: documentId);

    }catch(e){
      print("Error Deleting Task:$e");
      rethrow;
    }
   }
}