analysis:
	R < analyse.R --no-save

move_data:
	cp plot_data.csv html/data/

prep_blog:
	cp plots/* ~/dev/build-blog/media/img
	cp html/js/* ~/dev/build-blog/media/js
	cp plot_data.csv ~/dev/build-blog/media/data
