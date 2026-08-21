package tv.oneplay.app

import androidx.media3.extractor.Extractor
import androidx.media3.extractor.ExtractorsFactory
import androidx.media3.extractor.ts.TsExtractor

class TsOnlyExtractorFactory : ExtractorsFactory {
    override fun createExtractors(): Array<Extractor> {
        return arrayOf(TsExtractor())
    }
}
