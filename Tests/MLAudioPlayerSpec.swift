//
//  MLAudioPlayerSpec.swift
//  MLAudioPlayer
//
//  Created by Michel Anderson Lutz Teixeira on 04/10/16.
//  Copyright © 2017 micheltlutz. All rights reserved.
//

import Quick
import Nimble
@testable import MLAudioPlayer

class MLAudioPlayerSpec: QuickSpec {

    override func spec() {

        describe("MLAudioPlayerSpec") {
            it("works") {
                expect(MLAudioPlayer.name) == "MLAudioPlayer"
            }
        }

    }

}
