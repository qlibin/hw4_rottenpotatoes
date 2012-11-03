# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
  end
  #flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  actual_movie_titles = all('table#movies tr td:first')
  e1_index = -1
  e2_index = -1
  actual_movie_titles.each_with_index do |title, i|
    if title.text == e1
      e1_index = i
    end
    if title.text == e2
      e2_index = i
    end
  end
  assert e1_index > -1
  assert e2_index > e1_index
end

Then /I should see movies in alphabetical order/ do
  movies = Movie.find_all_by_rating(:order => 'title')
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(/,\s*/).each { |rating|
    When %{I #{uncheck}check "ratings_#{rating}"}
  }
end


Then /I should see all of the movies with ratings: (.*)/ do |rating_list|
  movies = Movie.find_all_by_rating(rating_list.split(/,\s*/))
  table_rows = all('table#movies tr')
  assert(table_rows.size == movies.size + 1)
  #movies.each do |movie|
  #  Then %{I should #{negative}see "#{movie.title}"}
  #end
end

Then /I should not see all of the movies with ratings: (.*)/ do |rating_list|
  ratings = Movie.all_ratings - rating_list.split(/,\s*/)
  movies = Movie.find_all_by_rating(ratings)
  table_rows = all('table#movies tr')
  assert (table_rows.size == movies.size + 1)
  #movies.each do |movie|
  #  Then %{I should #{negative}see "#{movie.title}"}
  #end
end

#Then /I should not see all of the movies with ratings: (.*)/ do |rating_list|
#  movies = Movie.find_all_by_rating(rating_list.split(/,\s*/))
#  table_rows.size.should == movies.size + 1
#  movies.each do |movie|
#    Then %{I should not see "#{movie.title}"}
#  end
#end

Then /I should (not )?see all of ratings selected: (.*) / do |negative, rating_list|
  ratings = rating_list.split(/,\s*/)
  #inputs = all("input[type=checkbox][name*=ratings][checked#{(negative == "not ")?'!':''}=checked]")
  #all("input#ratings_G")[0].checked?
  #assert (inputs.size == ratings.size)
  ratings.each { |rating|
    Then %{the "ratings_#{rating}" checkbox should #{negative}be checked}
  }
end
Then /^the director of "([^"]*)" should be "([^"]*)"$/ do |movieTitle, directorName|
  movie = Movie.find_by_title movieTitle
  assert directorName == movie.director
end