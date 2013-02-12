# Declaracion para comprobar la existencia de un grupo de peliculas como background
# o si no crearlas

Given /the following movies exist/ do |movies_table|

  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    if not Movie.exists?(:title => movie[:title], :rating => movie[:rating], :release_date => movie[:release_date]) then
      Movie.create!(:title => movie[:title], :rating => movie[:rating], :release_date => movie[:release_date])
    end #if
  end #each
  
end #Given
# ============================================

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  page.body.gsub(/\n/,"").should match(".*"+e1.to_s+".*"+e2.to_s+".*")
end
# ============================================

# Compruebo que aparecen las peliculas en el orden indicado y solamente estas
Then /I should see movies ordered by (\w*):/ do |order, movies_table|
  regexp = ".*"
  movies_table.hashes.each do |movie|
    regexp += movie[order.to_sym].to_s + ".*"
  end #each

  #puts order  
  #puts regexp
  #puts page.body.gsub(/\n/,"").match(regexp)
  
  page.body.gsub(/\n/,"").should match(regexp)
end #Then
# ============================================

# Paso que implementa el marcado / desmarcado de varios check simultaneo
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|

  rating_list.split(%r{,\s*}).each do |rating|
    if uncheck == "un" then 
      step %{I uncheck "ratings[#{rating}]"}
      puts %{unchecking "ratings[#{rating}]"}
    else
      step %{I check "ratings[#{rating}]"}
      puts %{checking "ratings[#{rating}]"}
    end #else
  end #each

end #When
# ============================================

# Comprueba que se ven unicamente las peliculas indicadas
#  "Then I should see exactly all the movies rated: PG, R"
Then /I should see exactly all the movies rated: (.*)/ do |rating_list|
  
  movie_counter = 0
  
  rating_list.split(%r{,\s*}).each do |rating|
    movies_rated = Movie.find_all_by_rating(rating)
    movie_counter += movies_rated.count
    movies_rated.each do |movie|
      step %{I should see "#{movie.title}"}
    end #each movie
  end #each rating
  
  page.should have_css("table#movies tbody tr", :count => movie_counter)
  
end #Then
# ============================================

Then /I should see all of the movies/ do
  
  all_movies = Movie.all
  all_movies.each do |movie|
    step %{I should see "#{movie.title}"}
  end #each
  
  page.should have_css("table#movies tbody tr", :count => all_movies.count)
  
end #then
# ============================================

# Comprueba que el director de la película es el indicado
Then /the director of "(.*)" should be "(.*)"/ do |title, director|

  Movie.find_by_title(title).director.should == director

end #then
# ============================================
