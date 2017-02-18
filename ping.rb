# ホストのPeerCastのバージョンを取得する。

require 'socket'
require_relative 'atom'

include Atom

if ARGV.size == 0
  puts "Usage: ruby ping.rb IP:PORT [IP:PORT...]"
  exit 1
end

ARGV.each do |tip|
  unless tip =~ /^([^:]+):(\d+)$/
    STDERR.puts "invalid endpoint #{tip.inspect}"
  end

  host = $1
  port = $2.to_i

  serv = TCPSocket.new(host, port)
  serv.write Atom::Integer.new(PCP_CONNECT, 1)

  helo = Atom::Parent.new(PCP_HELO)
  helo << Atom::String.new(PCP_HELO_AGENT, PCX_AGENT)
  helo << Atom::Integer.new(PCP_HELO_VERSION, 1218)
  helo << Atom::Bytes.new(PCP_HELO_SESSIONID, "1234567890123456")
  serv.write helo

  atom = Atom::read(serv)
  p atom
end
