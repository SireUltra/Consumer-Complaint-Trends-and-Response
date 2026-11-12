SELECT *,
		year(date_submitted),
        month(date_submitted),
        datediff(date_received, date_submitted) as complaint_processing_timeline
FROM consumer.consumer_complaints;
