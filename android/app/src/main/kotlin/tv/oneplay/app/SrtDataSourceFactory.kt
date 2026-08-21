package tv.oneplay.app

import androidx.media3.datasource.DataSource

class SrtDataSourceFactory :
    DataSource.Factory {
    override fun createDataSource(): DataSource {
        return SrtDataSource()
    }
}
