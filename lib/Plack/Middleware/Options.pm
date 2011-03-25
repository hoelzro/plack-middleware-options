package Plack::Middleware::Options;

use strict;
use warnings;
use parent 'Plack::Middleware';

our $VERSION = '0.01';

sub prepare_app {
    my ( $self ) = @_;

    my $allowed = $self->{'allowed'};
    if(ref $allowed eq 'ARRAY') {
        $allowed = { map { $_ => 1 } @$allowed };
    } elsif(ref $allowed ne 'HASH') {
        $allowed = {
            DELETE => 1,
            GET    => 1,
            HEAD   => 1,
            POST   => 1,
            PUT    => 1,
        };
    }
    $self->{'allowed'} = $allowed;
}

sub call {
    my ( $self, $env ) = @_;

    my $method = $env->{'REQUEST_METHOD'};

    if($method eq 'OPTIONS') {
        return [
            200,
            ['Allow' => join(', ', keys %{ $self->{'allowed'} })],
            [],
        ];
    } elsif(exists $self->{'allowed'}{$method}) {
        return $self->app->($env);
    } else {
        return [
            405,
            ['Content-Type' => 'text/plain'],
            ['Method not allowed'],
        ];
    }
};

1;

__END__

=head1 NAME

Plack::Middleware::Options - Implements OPTIONS and filters out unknown methods

=head1 VERSION

0.01

=head1 SYNOPSIS

  use Plack::Builder;

  builder {
      enable 'Options', allowed => [qw/GET POST HEAD/];
      $app;
  };

=head1 DESCRIPTION

This module implements the OPTIONS HTTP method for your Plack application.
It also returns a 405 Method Not Allowed error when a method not explicitly
allowed is used.

=head1 AUTHOR

Rob Hoelz, C<< rob at hoelz.ro >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-Plack-Middleware-Options at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Plack-Middleware-Options>. I will
be notified, and then you'll automatically be notified of progress on your bug as I make changes.

=head1 COPYRIGHT & LICENSE

Copyright 2011 Rob Hoelz.

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=head1 SEE ALSO

L<Plack>, L<Plack::Middleware>

=begin comment

Undocumented method (for Pod::Coverage)

=over

=item prepare_app
=item call

=back

=cut
