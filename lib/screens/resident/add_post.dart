import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:smart_supply_chain_management_fyp/models/post.dart';
import 'package:smart_supply_chain_management_fyp/utils/locationService.dart';

import '../../firebase/post.dart';
import '../../models/tag.dart';


class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {

  final TextEditingController _tagController = TextEditingController();
  TextEditingController _textEditingController=TextEditingController();
bool isLoading=false;
  double userLatitude=0.0;
  double userLongitude=0.0;
  List<Tag> _tags = [];


  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
    getLocation();
  }


  getLocation() async{
    LocationService locationService=LocationService();
    LatLng latLong = await locationService.getPosition();
    userLatitude = latLong.latitude;
    userLongitude = latLong.longitude;
  }

  @override
  Widget build(BuildContext context) {
    final width=MediaQuery.sizeOf(context).width;
    final height=MediaQuery.sizeOf(context).height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: ElevatedButton(onPressed: () async {
            if(_textEditingController.text==''  ){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Write something')));
            }
            else if(_tags.length!=3){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Enter tags')));
            }
else{
  setState(() {
    isLoading=true;
  });

              Post post=Post(postData: _textEditingController.text, dateTime: DateTime.now(),lat: userLatitude,long: userLongitude, tags: _tags.map((tag) => tag.name).toList());
              PostService postService=PostService();
                await postService.createPost(post);
  setState(() {
    isLoading=false;
  });
              Navigator.pop(context,1);
            }
          }, child:isLoading?CircularProgressIndicator(): Text('Post')),
        )
      ]),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: height*0.4,
            padding: EdgeInsets.all(10),
            child:
            TextFormField(
              maxLines: 20,
              autofocus: true,
                controller: _textEditingController,
                decoration: InputDecoration(border: OutlineInputBorder()),
            ),

          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                _tags.length==3
                    ?
                Container()
                    :
                TextField(
                  controller: _tagController,
                  decoration: InputDecoration(
                    hintText: 'Type a tag and press Enter',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (String value) {
                    if (value.isNotEmpty) {
                      bool tagExists = _tags.any((tag) => tag.name.toLowerCase() == value.toLowerCase());

                      if (!tagExists) {
                        setState(() {
                          _tags.add(Tag(name: value));
                          _tagController.clear();
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Tag already exists'),
                        ));
                      }
                    }
                  },
                ),
                Wrap(
                  children: _tags.map((tag) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Chip(
                        label: Text(tag.name),
                        onDeleted: () {
                          setState(() {
                            _tags.remove(tag);
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),

              ],
            ),
          )
        ],
      ));
  }
}
