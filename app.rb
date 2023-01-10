require_relative 'book'
require_relative 'label'
require 'json'

class App
  def initialize
    @books = []
    @albums = []
    @games = []
    @genres = []
    @labels = []
    @authors = []
    list_books_stored
    list_labels_stored
  end

  def menu
    puts "\n\nWelcome to Catalog of my things \n 1 - List all books\n 2 - List all music albums\n 3 - List of games\n
 4 - List all genres\n 5 - List all labels\n 6 - List all authors\n 7 - Add a book\n 8 - Add a music album\n
 9 - Add a game\n 10- Quit the App\n"
    action = gets.chomp.to_i
    if action < 10 && action.positive?
      select(action)
    elsif action == 10
      puts 'Bye!'
    else
      menu
    end
  end

  def select(action)
    case action
    when 1
      list_all_books

    when 5
      list_all_labels

    when 7
      add_a_book
    end
  end

  def add_a_book
    puts "\nPublisher\n"
    publisher = gets.chomp
    puts "\nCover state\n"
    cover = gets.chomp
    puts "\nPublish date dd/mm/yy \n"
    date = gets.chomp
    book = Book.new(publisher, cover, date)
    @books.push(book)
    puts "\nWould you like to add a label? (1) - YES // (2) - NO\n"
    option = gets.chomp.to_i
    if option == 1
      puts "\nChoose a title for the label\n"
      label_title = gets.chomp
      puts "\nChoose a color for the label\n"
      label_color = gets.chomp
      label = Label.new(label_title, label_color)
      @labels.push(label)
    end
    save_all_labels_books
  end

  def save_all_labels_books
    bjson = []
    @books.each do |book|
      bjson.push({ publisher: book.publisher, cover_state: book.cover_state, date: book.publish_date })
    end
    bookson = JSON.generate(bjson)
    File.write('books.json', bookson)
    ljson = []
    @labels.each do |label|
      ljson.push({ title: label.title, color: label.color })
    end
    labson = JSON.generate(ljson)
    File.write('labels.json', labson)
    menu
  end

  def list_books_stored
    if File.exist?('books.json') && !File.zero?('books.json')
      bookfile = File.open('books.json')
      bookjson = bookfile.read
      JSON.parse(bookjson).map do |book|
        boke = Book.new(book['publisher'], book['cover_state'], book['publish_date'])
        p boke
        @books.push(boke)
      end
      bookfile.close
    else
      File.new('books.json', 'w')
    end
  end

  def list_all_books
    if @books.empty?
      puts "\nThere are no books available\n"
    else
      @books.each do |book|
        puts "\nPublisher #{book.publisher} Cover #{book.cover_state} published #{book.publish_date}\n"
      end
    end
    menu
  end

  def list_all_labels
    if @labels.empty?
      puts "\nThere are no labels available"
    else
      @labels.each { |label| puts "\nLabel name #{label.title} of color #{label.color}\n" }
    end
    menu
  end

  def list_labels_stored
    if File.exist?('labels.json') && !File.zero?('labels.json')
      labelsfile = File.open('labels.json')
      labeljson = labelsfile.read
      JSON.parse(labeljson).map do |label|
        labe = Label.new(label['title'], label['color'])
        @labels.push(labe)
      end
      labelsfile.close
    else
      File.new('labels.json', 'w')
    end
  end
end
