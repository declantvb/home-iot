print('updater.lua started')
host, port, path = '192.168.1.75', 3000, '/updater/'

pgm = 'program.lua'
fileOpen = file.open(pgm, 'r')
if (fileOpen) then versionString = file.readline() end
if (versionString) then
	versionOffset = string.find(versionString, ' ') 
	version = string.sub(versionString, versionOffset+1, -3)
else version = '0.0.0' end
print(version) file.close() payloadFound = false

conn = net.createConnection(net.TCP, 0)
conn:on('receive', function(conn, payload)
    if (payloadFound) then
		file.open(pgm, 'w+')
		file.write(payload)
		file.flush()
    else 
		statusOffset = string.find(payload, ' ');
		status = string.sub(payload, statusOffset+1, statusOffset+3)
		print(status)
		payloadOffset = string.find(payload, '\r\n\r\n')
		if (payloadOffset and status == '200') then
			payloadFound = true
		end
	end
end)
conn:on('connection', function(conn)
	payloadFound = false
	conn:send('GET '..path..version..' HTTP/1.1\r\n'
		..'Host: '..host..'\r\n'
		..'Connection: close\r\n\r\n')
end)
conn:on('disconnection', function(conn)
	file.close()
	dofile(pgm)
end)
conn:connect(port, host) 