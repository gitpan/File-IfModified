package File::IfModified;
use 5.008001;
use strict;
use Exporter 'import';
our @EXPORT_OK = qw(if_modified touch);
our $VERSION = qw(0.10);

my %mtime;
sub if_modified{
    my $file = shift;
    my $mtime = (stat $file)[9];
    if ( defined $mtime ){
        if ( exists $mtime{$file} ){
            return if ( $mtime{$file} eq $mtime );
        }
        $mtime{ $file } = $mtime;
        return 1;
    }
    else {
        delete $mtime{$file};
        return 1;
    }
}
sub touch{
    my $file = shift;
    open my $fh, "+>", $file or die "touch: $file";
    close $fh;
    delete $mtime{$file};
}
1;
__END__
=head1 NAME

File::IfModified - Perl extension for checking if-modified state of file

=head1 SYNOPSIS

  use File::IfModified qw(if_modified);

  my $cached_data;
  my $file = 'data for initialization of $cached_data';
  while( 1 ){
    if ( if_modified( $file ){
      
        # Open $file and
        # Init $cached_data
        ...
    } 
    # Use $cached_data
    ... 
    sleep 1;
  }

=head1 DESCRIPTION

  This module usefull for long running script with external dependenses on other files

=head2 EXPORT

None by default.


=head1 SEE ALSO

    L<File-Modified>.

=head1 AUTHOR

A. G. Grishaev, E<lt>grian@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by A. G. Grishaev

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.14.1 or,
at your option, any later version of Perl 5 you may have available.


=cut
