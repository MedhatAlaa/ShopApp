import 'package:flutter/material.dart';

class DescriptionScreen extends StatelessWidget {
  const DescriptionScreen({
    Key? key,
    required this.description,
    required this.image,
    required this.price,
    required this.name,
  }) : super(key: key);
  final String description;
  final String image;
  final String name;
  final dynamic price;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Image(
              image: NetworkImage(
                image,
              ),
              height: 250.0,
              width: double.infinity,
            ),
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(height: 10.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Price: ',
                        style: TextStyle(color: Colors.black),
                      ),
                      Text(
                        '$price',
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Container(
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(30.0),
                  topLeft: Radius.circular(30.0),
                ),
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.black54,
                      Colors.blue[700]!,
                      Colors.redAccent,
                    ]),
              ),
              child: Text(
                description,
                style: const TextStyle(
                  height: 1.5,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
