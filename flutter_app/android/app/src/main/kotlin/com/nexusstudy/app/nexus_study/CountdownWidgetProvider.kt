package com.nexusstudy.app.nexus_study

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews

class CountdownWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        val prefs = context.getSharedPreferences("nexus_widget_prefs", Context.MODE_PRIVATE)
        val school = prefs.getString("target_school", "難関大学・志望校") ?: "難関大学・志望校"
        val dev = prefs.getFloat("target_deviation", 65.0f)
        val days = prefs.getInt("countdown_days", 130)

        for (appWidgetId in appWidgetIds) {
            val intent = Intent(context, MainActivity::class.java).apply {
                putExtra("route", "/home")
            }
            val pendingIntent = PendingIntent.getActivity(
                context, 1, intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            val views = RemoteViews(context.packageName, R.layout.countdown_widget_layout)
            views.setTextViewText(R.id.widget_school_name, "志望校: " + school)
            views.setTextViewText(R.id.widget_target_dev, "目標 " + String.format("%.1f", dev))
            views.setTextViewText(R.id.widget_countdown_days, days.toString())
            views.setOnClickPendingIntent(R.id.countdown_widget_container, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
