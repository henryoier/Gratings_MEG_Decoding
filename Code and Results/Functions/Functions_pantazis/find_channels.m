function channel_ndx = find_channels(Channel,str)

channel_ndx = [];
for i = 1:length(Channel)
    if strfind(Channel(i).Type,str)
        channel_ndx = [channel_ndx i];
    end
end