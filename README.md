# build-nginx-php-ci

## Getting started


## build cmd 

docker build -t nginx-php-codeigniter3:v1 . --no-cache

To achieve this in **CodeIgniter 3.1.13**, follow these steps:

---

### **Step 1: Add Route in `routes.php`**
You need to add a custom route in `application/config/routes.php` to define `http://localhost/test`.

```php
$route['test'] = 'TestController/index';
```

---

### **Step 2: Create Controller (TestController.php)**
Create a new file in `application/controllers/` and name it **TestController.php**.

```php
<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class TestController extends CI_Controller {

    public function index()
    {
        // Call the CURL function
        $data['api_response'] = $this->fetch_data();

        // Load view and pass data
        $this->load->view('test_view', $data);
    }

    private function fetch_data()
    {
        // Initialize CURL
        $curl = curl_init();

        // Set CURL options
        curl_setopt_array($curl, array(
            CURLOPT_URL => "https://jsonplaceholder.typicode.com/todos/",
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_SSL_VERIFYPEER => false, // Ignore SSL verification
        ));

        // Execute CURL request
        $response = curl_exec($curl);

        // Close CURL session
        curl_close($curl);

        return $response;
    }
}
```

---

### **Step 3: Create a View (test_view.php)**
Now, create a view file in `application/views/` and name it **test_view.php**.

```php
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test API Response</title>
</head>
<body>
    <h2>API Response</h2>
    <pre><?php echo $api_response; ?></pre>
</body>
</html>
```

---

### **Step 4: Run in Browser**
Now, start your local server and open:

```
http://localhost/test
```

It will fetch data from **https://jsonplaceholder.typicode.com/todos/** and display it on the page.

---

### **Extra: JSON Response as an API**
If you want to return the JSON response instead of rendering a view, modify the `index` method in `TestController.php` like this:

```php
public function index()
{
    header('Content-Type: application/json');
    echo $this->fetch_data();
}
```

Now, visiting `http://localhost/test` will return raw JSON data.

Let me know if you need further modifications! 🚀

# add parameter 

To allow passing a parameter (e.g., `http://localhost/test/1`) and dynamically fetching data from `https://jsonplaceholder.typicode.com/todos/1`, follow these steps:

---

### **Step 1: Update Route in `routes.php`**
Modify `application/config/routes.php` to allow dynamic parameters:

```php
$route['test/(:num)'] = 'TestController/index/$1';
```

This tells CodeIgniter to accept a numeric parameter in the URL.

---

### **Step 2: Modify `TestController.php`**
Update the `index()` method to accept an ID and fetch data dynamically.

```php
<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class TestController extends CI_Controller {

    public function index($id = null) 
    {
        if ($id === null) {
            show_404(); // Show 404 error if no ID is provided
        }

        // Call the CURL function with the provided ID
        $data['api_response'] = $this->fetch_data($id);

        // Load view and pass data
        $this->load->view('test_view', $data);
    }

    private function fetch_data($id) 
    {
        // Initialize CURL
        $curl = curl_init();

        // Set CURL options
        curl_setopt_array($curl, array(
            CURLOPT_URL => "https://jsonplaceholder.typicode.com/todos/" . $id,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_SSL_VERIFYPEER => false, // Ignore SSL verification
        ));

        // Execute CURL request
        $response = curl_exec($curl);

        // Close CURL session
        curl_close($curl);

        return $response;
    }
}
```

---

### **Step 3: Update `test_view.php`**
Ensure the response is displayed correctly.

```php
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test API Response</title>
</head>
<body>
    <h2>API Response</h2>
    <pre><?php echo $api_response; ?></pre>
</body>
</html>
```

---

### **Step 4: Run in Browser**
Now, test with different IDs in your browser:

```
http://localhost/test/1
http://localhost/test/5
http://localhost/test/10
```

Each request will dynamically fetch data from:

```
https://jsonplaceholder.typicode.com/todos/1
https://jsonplaceholder.typicode.com/todos/5
https://jsonplaceholder.typicode.com/todos/10
```

---

### **Optional: JSON Response Instead of View**
If you want to return JSON data directly instead of rendering a view, modify `index()` like this:

```php
public function index($id = null)
{
    if ($id === null) {
        show_404();
    }

    header('Content-Type: application/json');
    echo $this->fetch_data($id);
}
```

Now, visiting `http://localhost/test/1` will return raw JSON data.

---

This setup allows dynamic API requests based on the URL parameter. 🚀 Let me know if you need modifications! 😊

