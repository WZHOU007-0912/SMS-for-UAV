'''
This script aims at processing the ASN Database for drone accidengts, 
which is in file "ASNdronesdb_1585161223.htm"
'''

data <- readLines("ASNdronesdb_1585161223.htm")
data <- iconv(enc2utf8(data),sub="byte")# solve nchar error when "Montreal" appears

# discard header
data <- data[3:length(data)]

# process first and last line
data[1] = substr(data[1], 123, nchar(data[1]))
data[length(data)] <- substr(data[length(data)], 1, 17)

newData = data.frame()

i = 1
while(i < length(data)){
    time <- data[i]
    time <- substr(time, 7, nchar(time)-8)
    i = i + 1
    
    location <- data[i]
    location <- substr(location, 4, nchar(location)-4)
    i = i + 1
    
    aircraft1 <- data[i]
    aircraft1 <- substr(aircraft1, 4, nchar(aircraft1) - 4)
    i = i + 1
    
    aircraft2 <- data[i]
    aircraft2 <- substr(aircraft2, 4, nchar(aircraft2) - 4)
    i = i + 1
    
    altitude <- data[i]
    altitude <- substr(altitude, 31, nchar(altitude) - 5)
    i = i + 1
    
    separation <- data[i]
    separation <- substr(separation, 16, nchar(separation) - 4)
    i = i + 1
    
    evasiveManoeuvre <- data[i]
    evasiveManoeuvre <- substr(evasiveManoeuvre, 23, nchar(evasiveManoeuvre) - 4)
    i = i + 1
    
    description <- data[i]
    description <- substr(description, 4, nchar(description)-4)
    i = i + 1
    
    temp <- data[i]
    while(substr(temp, 4, 10)!="Source:"){
        temp <- substr(temp, 4, nchar(temp) - 4)
        description = paste(description, temp, sep = " ")
        i = i + 1
        temp <- data[i]
    }
    
    source <- substr(temp, 12, nchar(temp)-4)
    i = i + 1
    
    newLine = data.frame("time" = time, "location" = location, "aircraft1" = aircraft1, 
                         "aircraft2" = aircraft2, "altitude" = altitude, 
                         "separation" = separation, "evasive manoeuvre" = evasiveManoeuvre,
                         "description" = description, "source" = source)
    newData = rbind(newData, newLine)
}

write_csv(newData, "ASNDatabase.csv")
