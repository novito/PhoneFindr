################ Devise brands ################
brands = ['Nokia', 'Samsung', 'Motorola', 'Sony', 'LG', 'Apple', 'HTC', 'BlackBerry',
 'HP', 'Huawei', 'Acer', 'Asus', 'Alcatel', 'Vodafone', 'T-Mobile', 'Toshiba',
 'Gigabyte', 'Pantech', 'ZTE', 'Xolo', 'Micromax', 'BLU', 'Spice', 'Karbonn',
 'Prestigio', 'verykool', 'Unnecto', 'Maxwest', 'Celkon', 'Gionee', 'NIU', 
 'Yezz', 'Parla', 'Plum']

brands.each do |brand_name|
  Brand.find_or_create_by(name: brand_name)
end




