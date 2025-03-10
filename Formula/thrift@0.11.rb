class ThriftAT011 < Formula
  desc "Framework for scalable cross-language services development"
  homepage "https://thrift.apache.org"
  url "https://archive.apache.org/dist/thrift/0.11.0/thrift-0.11.0.tar.gz"
  sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855 "
  license "Apache-2.0"

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "openssl@3"

  uses_from_macos "flex" => :build

  def install
    args = %W[
      --without-erlang
      --without-haskell
      --without-java
      --without-perl
      --without-php
      --without-php_extension
      --without-python
      --without-ruby
      --without-swift
      --disable-tests
      --disable-tutorial
      --with-ssl=#{Formula["openssl@3"].opt_prefix}
    ]

    ENV.cxx11 if ENV.compiler == :clang

    # Don't install extensions to /usr
    ENV["JAVA_PREFIX"] = pkgshare/"java"

    # Regenerate the configure script
    system "./bootstrap.sh"

    system "./configure", *std_configure_args, *args
    ENV.deparallelize
    system "make", "install"
  end

  test do
    assert_match "Thrift", shell_output("#{bin}/thrift --version")
  end
end
