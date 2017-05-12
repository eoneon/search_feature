10.times do
  Article.create(:title => Faker::Lorem.word, :description => Faker::Lorem.sentence, :status => 0)
  Article.create(:title => Faker::Lorem.word, :description => Faker::Lorem.sentence, :status => 1)
  Article.create(:title => Faker::Lorem.word, :description => Faker::Lorem.sentence, :status => 2)
  Article.create(:title => Faker::Lorem.word, :description => Faker::Lorem.sentence, :status => 3)
end

10.times do
 Article.create(:title => Faker::Lorem.word, :description => Faker::Lorem.sentence, :status => 0,:website => Faker::Internet.domain_name)
 Article.create(:title => Faker::Lorem.word, :description => Faker::Lorem.sentence, :status => 1,:author => Faker::Name.first_name)
 Article.create(:title => Faker::Lorem.word, :description => Faker::Lorem.sentence, :status => 2,:meta_title => Faker::Lorem.word)
 Article.create(:title => Faker::Lorem.word, :description => Faker::Lorem.sentence, :status => 3,:meta_description => Faker::Lorem.sentence)
end
