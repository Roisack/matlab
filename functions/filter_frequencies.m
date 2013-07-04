function output = filter_frequencies(data, channels, sampling_frequency, frequency_start, frequency_stop, pass)
% Applies a butterworth filter to the given soundfile, then writes the result in a new file
% Parameters are:
%   * data: A vector containing the audio data
%   * channels: The number of channels in the wav file. Either 1 or 2
%   * sampling_frequency: The frequency used in the audio file. Can be figured with [sounddata, sampling_frequency] = wavread(filepath)
%   * frequency_start: The starting frequency for band-pass and stop-pass, and the border frequency for low-pass and high-pass
%   * pass: high for high-pass filter, low for low-pass filter, stop for stop-pass filter, baseband for baseband filter
%

normalized_frequency = frequency_start / (sampling_frequency/2);

if (channels == 1)
    if (strcmp(pass, 'low') == 1)
        [b, a] = butter(10, normalized_frequency, 'low');
        filtered_sound = filtfilt(b, a, data);
    elseif (strcmp(pass, 'high') == 1)
        [b, a] = butter(10, normalized_frequency, 'high');
        filtered_sound = filtfilt(b, a, data);
    elseif (strcmp(pass, 'bandpass') == 1)
        fNorm = [frequency_start / (sampling_frequency), frequency_stop / (sampling_frequency/2)];
        [b, a] = butter(10, fNorm, 'bandpass');
        filtered_sound = filter(b, a, data);
    elseif (strcmp(pass, 'stop') == 1)
        fNorm = [frequency_start / (sampling_frequency/2), frequency_stop / (sampling_frequency/2)];
        [b, a] = butter(10, fNorm, 'stop');
        filtered_sound = filter(b, a, data);
    end
    output = filtered_sound;
elseif (channels == 2)
    left_channel = data(:,1);
    right_channel = data(:,2);
    
    if (strcmp(pass, 'low') == 1)
        [b, a] = butter(10, normalized_frequency, 'low');
        filtered_sound_left = filtfilt(b, a, left_channel);
        filtered_sound_right = filtfilt(b, a, right_channel);
    elseif (strcmp(pass, 'high') == 1)
        [b, a] = butter(10, normalized_frequency, 'high');
        filtered_sound_left = filtfilt(b, a, left_channel);
        filtered_sound_right = filtfilt(b, a, right_channel);
    elseif (strcmp(pass, 'bandpass') == 1)
        fNorm = [frequency_start / (sampling_frequency/2), frequency_stop / (sampling_frequency/2)];
        [b, a] = butter(10, fNorm, 'bandpass');
        filtered_sound_left = filtfilt(b, a, left_channel);
        filtered_sound_right = filtfilt(b, a, right_channel);
    elseif (strcmp(pass, 'stop') == 1)
        fNorm = [frequency_start / (sampling_frequency/2), frequency_stop / (sampling_frequency/2)];
        [b, a] = butter(10, fNorm, 'stop');
        filtered_sound_left = filtfilt(b, a, left_channel);
        filtered_sound_right = filtfilt(b, a, right_channel);
    end
    stereo_channel = [filtered_sound_left(:), filtered_sound_right(:)];
    output = stereo_channel;
else
    output = 0;
end


