function output = split_frequencies(input_filepath, channels, pass)
% Splits a soundfile in multiple files, each having only a specific range of frequencies
% Parameters are:
%   * input_filepath: A .wav file containing the original soundfile
%   * channels: The number of channels in the audio file. 1 for mono, 2 for stereo
%   * the form of filtering: low for removing everything above frequency x, high for removing everything below, stop for removing a specific range of frequencies, frequencies, bandpass for removing everything but a range of frequencies

[soundfile, sampling_frequency] = wavread(input_filepath);
input_filepath_noextension = fileparts(input_filepath);

step_size = 2000;
for current_frequency = 1:step_size:sampling_frequency
    frequency_start = current_frequency;
    frequency_stop = current_frequency + step_size;
    output_filepath = sprintf('%s/%s-pass_frequency_%d.wav', input_filepath_noextension, pass, current_frequency);
    filtered_data = filter_frequencies(soundfile, channels, sampling_frequency, frequency_start, frequency_stop, pass);

    t = 0:1/sampling_frequency:(length(filtered_data)-1)/sampling_frequency;
    n = length(filtered_data)-1;
    f = 0:sampling_frequency/n:sampling_frequency;
    sound_fft = abs(fft(filtered_data));
    p = figure('visible', 'off');
    plot(f, sound_fft);
    xlabel('Frequency in Hz');
    ylabel('Magnitude');
    
    frequency_title = sprintf('%s-pass filter with range %d to %d', pass, frequency_start, frequency_stop);
    title(frequency_title);
    
    image_filename = sprintf('%s/%s-pass_frequency_%d.png', input_filepath_noextension, pass, current_frequency);
    saveas(p, image_filename, 'png');
    
    wavwrite(filtered_data, sampling_frequency, output_filepath);
end
