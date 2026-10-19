import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

// book model
class Book {
  final String title;
  final String author;
  final String description;
  final String imageUrl;

  Book({
    required this.title,
    required this.author,
    required this.description,
    required this.imageUrl,
  });
}

// states and cubit
abstract class BookState {}

class BookLoading extends BookState {}

class BookLoaded extends BookState {
  final List<Book> books;
  final String sortedBy;

  BookLoaded({required this.books, required this.sortedBy});
}

class BookDetailState extends BookState {
  final Book book;

  BookDetailState({required this.book});
}

class BookCubit extends Cubit<BookState> {
  BookCubit() : super(BookLoading()) {
    init();
  }
  List<Book> _books = []; //initially empty list 

  void init() {
    _books = [
    Book(
      title: 'Carmer and Grit',
      author: 'Sarah Jean Horwitz',
      description: 'lorem ipsum dolor sit amet consectetur adipiscing elit rerum in adipiscing accusamus ut adipiscing excepteur officia occaecat eligendi ullamco voluptate assumenda quod omnis dolore aliqua minus omnis est vero qui id optio temporibus harum ullamco dolores quo velit deserunt quas officia et in culpa dolor qui quos elit placeat mollitia',
      imageUrl: 'assets/images/book1.png',
    ),
    Book(
      title: 'The Imperfections of Memory',
      author: 'Angelina Aludo',
      description: 'lorem ipsum dolor sit amet consectetur adipiscing elit rerum in adipiscing accusamus ut adipiscing excepteur officia occaecat eligendi ullamco voluptate assumenda quod omnis dolore aliqua minus omnis est vero qui id optio temporibus harum ullamco dolores quo velit deserunt quas officia et in culpa dolor qui quos elit placeat mollitia',
      imageUrl: 'assets/images/book2.png',
    ),
    Book(
      title: 'The Big Deal',
      author: 'Hisham Al Gurg',
      description: 'lorem ipsum dolor sit amet consectetur adipiscing elit rerum in adipiscing accusamus ut adipiscing excepteur officia occaecat eligendi ullamco voluptate assumenda quod omnis dolore aliqua minus omnis est vero qui id optio temporibus harum ullamco dolores quo velit deserunt quas officia et in culpa dolor qui quos elit placeat mollitia',
      imageUrl: 'assets/images/book3.png',
    ),
    Book(
      title: 'Little Gods',
      author: 'Meng Jin',
      description: 'lorem ipsum dolor sit amet consectetur adipiscing elit rerum in adipiscing accusamus ut adipiscing excepteur officia occaecat eligendi ullamco voluptate assumenda quod omnis dolore aliqua minus omnis est vero qui id optio temporibus harum ullamco dolores quo velit deserunt quas officia et in culpa dolor qui quos elit placeat mollitia',
      imageUrl: 'assets/images/book4.png',
    ),
    Book(
      title: 'A Clockwork Orange',
      author: 'Anthony Burgess',
      description: 'lorem ipsum dolor sit amet consectetur adipiscing elit rerum in adipiscing accusamus ut adipiscing excepteur officia occaecat eligendi ullamco voluptate assumenda quod omnis dolore aliqua minus omnis est vero qui id optio temporibus harum ullamco dolores quo velit deserunt quas officia et in culpa dolor qui quos elit placeat mollitia',
      imageUrl: 'assets/images/book5.png',
    ),
    Book(
      title: 'Dont Look Back',
      author: 'Isaac Nelson',
      description: 'lorem ipsum dolor sit amet consectetur adipiscing elit rerum in adipiscing accusamus ut adipiscing excepteur officia occaecat eligendi ullamco voluptate assumenda quod omnis dolore aliqua minus omnis est vero qui id optio temporibus harum ullamco dolores quo velit deserunt quas officia et in culpa dolor qui quos elit placeat mollitia',
      imageUrl: 'assets/images/book6.png',
    ),
    Book(
      title: 'James and the Giant Peach',
      author: 'Roald Dahl',
      description: 'lorem ipsum dolor sit amet consectetur adipiscing elit rerum in adipiscing accusamus ut adipiscing excepteur officia occaecat eligendi ullamco voluptate assumenda quod omnis dolore aliqua minus omnis est vero qui id optio temporibus harum ullamco dolores quo velit deserunt quas officia et in culpa dolor qui quos elit placeat mollitia',
      imageUrl: 'assets/images/book7.png',
    ),
  ];
  sortByAuthor();
  }
  void sortByAuthor(){
    emit(BookLoading());
    final sorted = List<Book>.from(_books)
      ..sort((a,b) => a.author.compareTo(b.author));
    emit(BookLoaded(books: sorted, sortedBy: 'author'));
  }
  void sortByTitle(){
    emit(BookLoading());
    final sorted = List<Book>.from(_books)
      ..sort((a,b) => a.title.compareTo(b.title));
    emit(BookLoaded(books: sorted, sortedBy: 'title'));
  }
  void selectBook(Book book){
    emit(BookDetailState(book:book));
  }
  void showBookList() {
      sortByAuthor();
  }
}


// ui widgets
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => BookCubit(),
        child: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookCubit, BookState>(
      builder: (context, state) {
        //if loading, show spinner
        if (state is BookLoading) {
          return const Scaffold(
            body: Center(child:CircularProgressIndicator()),
          );
        } 
        //home page
        else if (state is BookLoaded) {
          final books = state.books;
          final isAuthorSelected = state.sortedBy == 'author';

          return Scaffold(
            appBar: AppBar(title: const Text('Book Club Home'),),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('Sort by: '),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('Author'),
                        selected: isAuthorSelected,
                        onSelected: (selected){context.read<BookCubit>().sortByAuthor();},
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('Title'),
                        selected: !isAuthorSelected,
                        onSelected: (selected){context.read<BookCubit>().sortByTitle();},
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, 
                        crossAxisSpacing: 16, 
                        mainAxisSpacing: 16, 
                        childAspectRatio: 0.65,
                      ),
                      itemCount: books.length,
                      itemBuilder: (context, index){
                        final book = books[index];
                        return GestureDetector(
                          onTap: (){context.read<BookCubit>().selectBook(book);},
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: BookImageWidget(book: book),),
                              const SizedBox(height: 6),
                              Text(book.title, maxLines: 1, style: const TextStyle(fontWeight: FontWeight.bold),),
                              Text(book.author, style: const TextStyle(color:Colors.grey),),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        //detail page
        else if(state is BookDetailState){
          final book = state.book;
          return Scaffold(
            appBar: AppBar(
              title: Text(book.title),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back), 
                onPressed: () {context.read<BookCubit>().showBookList();},
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child:BookDetailWidget(book:book),
            ),
          );
        }
        return const Scaffold(
          body: Center(child: Text('Unknown State')),
        );
      },
    );
  }
}

class BookImageWidget extends StatelessWidget{
  final Book book;
  const BookImageWidget({super.key, required this.book});

  @override
  Widget build(BuildContext context){
    return Image.asset(
      book.imageUrl, 
      fit: BoxFit.cover,
      );
  }
}

class BookDetailWidget extends StatelessWidget{
  final Book book;
  const BookDetailWidget({super.key, required this.book});

  @override
  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //image
        Image.asset(book.imageUrl, height: 250, fit: BoxFit.cover,),
        const SizedBox(height: 16),
        
        //title
        Text(
          book.title, 
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height:8),
        
        //author
        Text(
          book.author,
          style: const TextStyle(fontSize: 16, color:Colors.grey),
        ),
        const SizedBox(height: 16),

        //description
        Text(
          book.description,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}

