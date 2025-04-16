from flask import Flask, jsonify
from celery_app import celery

app = Flask(__name__)

@app.route('/crawl', methods=['POST'])
def crawl():
    print("Crawling started")
    try:
        # Gửi task crawl dữ liệu tới Celery
        task = celery.send_task('tasks.crawl_data')
        return jsonify({'task_id': str(task.id), 'message': 'Crawling started'}), 202
    except Exception as e:
        print(f"Error sending task: {e}")
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)