function mp3_export() {
	// mp3_export()

	var fn, err, a, b;
	
	// Report missing instruments
	var missing_str = ""
	for (var i = 0; i < ds_list_size(instrument_list); i++) {
		var ins = instrument_list[| i]
		if (!ins.loaded && ins.filename != "" && ins.num_blocks > 0) {
			missing_str += ins.filename + "\n"
		}
	}
	if (missing_str != "") {
		if (!question("Some sounds could be not be loaded and will be missing from the exported track:\n\n" + missing_str + "\nWould you like to export anyway?", "Audio export")) {
			return 0
		}
	}
	
	var output_format = audio_exp_format
	var output_ext = "." + string_lower(output_format)
	
	fn = string(get_save_filename_ext(output_format + " files (*" + output_ext + ")|*" + output_ext, filename_new_ext(filename, "") + output_ext, filename_path(filename), condstr(language != 1, "Export audio track", "")))
	if (fn = "") return 0

	save_song(temp_file, true);
	
	var args = [temp_file, fn]
	var kwargs = {
		default_sound_path: sounds_directory,
		custom_sound_path: sounds_directory,
		ignore_missing_instruments: true,
		format: string_lower(output_format),
		sample_rate: audio_exp_sample_rate,
		channels: audio_exp_channels,
		include_locked_layers: audio_exp_include_locked
	}
	
	try {
		var result = python_call_function("audio_export", "main", args, kwargs);
	} catch (e) {
		if (language != 1) show_message("An error occurred while exporting the song:\n\n" + e)
		else show_message("导出歌曲时发生错误：\n\n" + e)
		return -1;
	}

	/*
	// Start
	err = audio_start(fn)
	if (err < 0) {
	    if (language != 1) message("There was an error when saving as MP3.\nError code: a" + string(err), "Error")
	    else message("导出 MP3 时发生错误。\n错误代码: a" + string(err), "错误")
	    return 0
	}

	// Add files
	with (obj_instrument) {
	    if (!loaded)
	        continue
	    buffer_save(sound_buffer, temp_file)
	    file_id = audio_file_add(temp_file)
	    if (file_id < 0) {
	        if (language != 1) message("There was an error when saving as MP3.\nError code: b" + string(err), "Error")
			else message("导出 MP3 时发生错误。\n错误代码: b" + string(err), "错误")
	        return 0
	    }
	}

	// Add sounds
	calculate_locked_layers()
	for (a = 0; a <= enda; a += 1) {
	    if (colamount[a] > 0) {
	        for (b = 0; b <= collast[a]; b += 1) {
	            if (song_exists[a, b] && (lockedlayer[b] = 0 || mp3_includelocked)) {
	                var ins = song_ins[a, b]; 
	                var key = song_key[a, b];
	                var vel = song_vel[a, b]; 
					var pit = song_pit[a, b];
					var keyshift = key + (ins.key + (pit/100) - 78)
	                if (ins.loaded) {
	                    err = audio_sound_add(ins.file_id,
	                                          a / tempo,
	                                          0.5 * power(2, keyshift / 12),
	                                          layervol[b] / 100 / 100 * vel)
	                    if (err < 0) {
	                        if (language != 1) message("There was an error when saving as MP3.\nError code: c" + string(err), "Error")
							else message("导出 MP3 时发生错误。\n错误代码: c" + string(err), "错误")
	                        return 0
	                    }
	                }
	            }
	        }
	    }
	}

	// Combine
	err = audio_combine()
	if (err < 0) {
	    if (language != 1) message("There was an error when saving as MP3.\nError code: d" + string(err), "Error")
	    else message("导出 MP3 时发生错误。\n错误代码: d" + string(err), "错误")
	    return 0
	}
	*/

	if (language != 1) {if (question("MP3 saved! Do you want to open it?", "MP3 Export")) open_url(fn)}
	else {if (question("MP3 已保存！现在打开吗？", "导出 MP3")) open_url(fn)}



}
