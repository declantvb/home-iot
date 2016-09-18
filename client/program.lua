--version: 0.0.1-alpha.5
host, port, path = '192.168.1.75', 3000, '/data'

file.open('program.lua', 'r')
versionString = file.readline()
versionOffset = string.find(versionString, ' ') 
version = string.sub(versionString, versionOffset+1, -3)

charge = 100
temp = 22;

data = '{"id": "'..node.chipid()..'",'
    .. '"charge": "'..charge..'",'
    .. '"version": "'..version..'",'
    .. '"data": {'
        .. '"temperature": "'..temp..'"'
    ..'}}'

sck = net.createConnection(net.TCP, 0)
sck:on('connection', function(sck)
	payloadFound = false
	sck:send('POST '..path..' HTTP/1.1\r\n'
		..'Host: '..host..'\r\n'
		..'Connection: close\r\n'
		..'Content-Type: application/json\r\n'
		..'Content-Length: ' .. data:len() .. '\r\n\r\n'
        ..data..'\r\n\r\n')
end)
sck:connect(port, host)