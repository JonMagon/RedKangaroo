module redkangaroo.security;

import std.datetime;
import std.digest.sha;
import std.conv;
import redkangaroo.config;

class OTP {
private:	
	long[] validationCandidates;
	
public:
	this() {		
		auto initialFrame = 
			Clock.currTime(UTC()).toUnixTime() / Config.RedKangaroo.stepWindow;
		
		validationCandidates ~= initialFrame;
		
		for (int i = 1; i <= Config.RedKangaroo.previousFrames; i++)
			validationCandidates ~= initialFrame - i;
		for (int i = 1; i <= Config.RedKangaroo.futureFrames; i++)
			validationCandidates ~= initialFrame + i;
	}
	
	bool checkToken(string reqToken) {
		foreach (frame; validationCandidates){
			auto genToken = toHexString!(LetterCase.lower)(
				sha256Of(
					Config.RedKangaroo.token ~
					to!string(frame)
				)
			);

			if (reqToken == genToken) return true;
		}
		
		return false;
	}

}