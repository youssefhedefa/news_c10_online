// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_c10_online/shared/api/api_manager.dart';
import 'package:news_c10_online/shared/routes.dart';
import 'package:news_c10_online/ui/artical_details_view/artical_details_view.dart';
import 'package:news_c10_online/ui/category_details/viewModel/CategoriesViewModel.dart';

import '../../model/sources_response/Source.dart';
import 'article_widget.dart';

class NewsListWidget extends StatefulWidget {
  Source source;
  NewsListWidget({Key? key,required this.source}) : super(key: key);

  @override
  State<NewsListWidget> createState() => _NewsListWidgetState();
}

class _NewsListWidgetState extends State<NewsListWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      context.read<CategoryDetailsViewModel>().getNews(widget.source.id??"");
      // Add Your Code here.

    });

  }
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: ApiManager.getNews(widget.source.id!),
        builder: (context , snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }else if(snapshot.hasError || snapshot.data?.status == "error"){
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(snapshot.data?.message??snapshot.error.toString()),
                ElevatedButton(onPressed: (){}, child: const Text("Try again"))
              ],
            );
          }
          var articles = snapshot.data?.articles??[];
          return ListView.separated(
              itemBuilder: (context , index)=> GestureDetector(
                onTap: (){
                  print('tp');
                  Navigator.pushNamed(context , Routes.articalDetails , arguments: articles[index]);
                },
                  child: ArticleWidget(news: articles[index],),),
              separatorBuilder: (context , index)=>const SizedBox(height: 20,),
              itemCount: articles.length
          );
        },
      ),
    );
  }
}
