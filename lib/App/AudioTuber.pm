package App::AudioTuber;

use strict;
use warnings;
use Image::Magick;
use Exporter qw(import);
use FFmpeg::Command;

our @EXPORT_OK = qw(generateImage coverArt renderVideo);

# Generate background image
sub generateImage {
	my $href = shift;
	my $image = $href->{image};
	my $title = $href->{title};
	my $artist = $href->{artist};
	my $composer = $href->{composer};

	my $filename = 'audiotuber.png';

	# Generate image caption
	my $text = '';
	$text .= "$title\n" if $title;
	$text .= "$artist\n" if $artist;
	$text .= "$composer\n" if $composer;

	# Create a new ImageMagick object
	my $object = Image::Magick->new;

	# If a background image was specified, use it
	if ($image && -e $image) {
		# Open image for reading
		$object->Read($image);
		# Scale it to 1280x720
		$object->Resize(geometry=>'1280x720');
		$object->Extent(gravity=>'Center', geometry=>'1280x720', background=>'black');
	} else {
		# Otherwise make a blank image
		$object->Set(size=>'1280x720');
		$object->ReadImage('canvas:white');
	}

	# Regardless of image origin, add the text
	$object->Annotate(pointsize=>40, stroke=>'black', fill=>'white', text=>$text, gravity=>'South');

	# Finally write out the temp image file
	$object->Write(filename=>$filename, compression=>'None');

	# Clean up ImageMagick
	undef $object;

	return $filename;
}

sub coverArt {
	my $href = shift;
	my $ffmpeg = $href->{ffmpeg};
	my $mp3 = $href->{mp3};

	# New FFmpeg object
	my $ff = FFmpeg::Command->new($ffmpeg);
	$ff->input_file($mp3) or die $ff->errstr;
	$ff->output_file('cover.png') or die $ff->errstr;

	if ($ff->exec()) {
		return 'cover.png';
	} else {
		return;
	}
}

sub renderVideo {
	my $href = shift;
	my $ffmpeg = $href->{ffmpeg};
	my $imagefile = $href->{imagefile};
	my $mp3 = $href->{mp3};
	my $basename = $href->{basename};

	# New FFmpeg object
	my $ff = FFmpeg::Command->new($ffmpeg);
	$ff->input_file([$imagefile, $mp3]);
	$ff->output_file("$basename.mkv");
	$ff->options(
		'-pix_fmt'   => 'yuv420p',
		'-loop'      => '1',
		'-framerate' => '2',
		'-c:v'       => 'libx264',
		'-preset'    => 'medium',
		'-tune'      => 'stillimage',
		'-crf'       => '18',
		'-c:a'       => 'aac',
	);
	$ff->exec() or die $ff->errstr;
	return;
}

# This ensures the lib loads smoothly
1;
