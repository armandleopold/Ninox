import java.util.*;
import java.io.*;
import kafka.javaapi.producer.Producer;
import kafka.producer.KeyedMessage;
import kafka.producer.ProducerConfig;
 
public class DataProducer {
    public static void main(String[] args) {
 
        Properties props = new Properties();
        props.put("metadata.broker.list", "172.254.0.7:9092");
        props.put("serializer.class", "kafka.serializer.StringEncoder");
        props.put("request.required.acks", "1");
 
        ProducerConfig config = new ProducerConfig(props);
 
        Producer<String, String> producer = new Producer<String, String>(config);

        //Open csv file
        String csvFile = "data.csv";
        BufferedReader br = null;
        String line = "";

        try {

            br = new BufferedReader(new FileReader(csvFile));
            while ((line = br.readLine()) != null) {
                KeyedMessage<String, String> data = new KeyedMessage<String, String>("incomingData", line);
                producer.send(data);
            }
        } catch(IOException e) {

        }

        producer.close();
    }
}