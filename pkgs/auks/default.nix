{ stdenv, autoreconfHook, libtirpc, slurm }:
stdenv.mkDerivation rec {
  pname = "auks";
  version = "v0.0.1";
  configureFlags = [
    "--with-tirpcinclude=${libtirpc.dev}/include/tirpc/"
    "--with-slurm"
  ];
  buildInputs = [ autoreconfHook slurm libtirpc ];
  src = ../..;

}