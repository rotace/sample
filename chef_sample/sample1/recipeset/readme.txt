
# Make cookbook

knife cookbook create [cookbook-name] -o [install-dir]

# excute recipe

sudo chef-solo -c ./recipeset/***.rb -j ./recipeset/***.json
