package com.mozart.web.teste;
import com.amazonaws.AmazonServiceException;
import com.amazonaws.SdkClientException;
import com.amazonaws.auth.EnvironmentVariableCredentialsProvider;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.DeleteObjectRequest;
import com.amazonaws.services.s3.model.S3Object;
import com.mozart.web.aws.AwsFileUtilities;

public class UploadImageAws {

	public static void main(String[] args) {
		String clientRegion = "sa-east-1";
        String bucketName = "innovatedevimagens";
        String stringObjKeyName = "fotosUsuarios\\Coelhar";
        String fileObjKeyName = "fotosUsuarios/Coelhar.jpg";
        String fileName = "C:\\Users\\provider.rpsilva\\Desktop\\Coelhar.jpg";

        S3Object fullObject = null, objectPortion = null, headerOverrideObject = null;
        
        try {
//        	BasicAWSCredentials awsCreds = new BasicAWSCredentials("access_key_id", "secret_key_id");
//        	AmazonS3 s3Client = AmazonS3ClientBuilder.standard()
//        							.withRegion(clientRegion)
//        	                        .withCredentials(new AWSStaticCredentialsProvider(awsCreds))
//        	                        .build();

//        	AmazonS3 s3Client = AmazonS3ClientBuilder.standard()
//					.withRegion(clientRegion)
//                    .withCredentials(new EnvironmentVariableCredentialsProvider())
//                    .build();
        	
            // Upload a text string as a new object.
            //s3Client.putObject(bucketName, stringObjKeyName, "Uploaded String Object");
            
            // Upload a file as a new object with ContentType and title specified.
//            PutObjectRequest request = new PutObjectRequest(bucketName, fileObjKeyName, new File(fileName));
//            ObjectMetadata metadata = new ObjectMetadata();
//            metadata.setContentType("plain/text");
//            metadata.addUserMetadata("x-amz-meta-title", "someTitle");
//            request.setMetadata(metadata);
//            s3Client.putObject(request);
            
//            System.out.println("Downloading an object");
//            fullObject = s3Client.getObject(new GetObjectRequest(bucketName, fileObjKeyName));
//            byte[] byteArray = IOUtils.toByteArray(fullObject.getObjectContent());
//            String logoStr2 = new String(Base64.encodeBase64(byteArray));
        		
        	new AwsFileUtilities().getFileBase64(bucketName, fileObjKeyName);
            //s3Client.deleteObject(new DeleteObjectRequest(bucketName, fileObjKeyName));
            
//            System.out.println("Content-Type: " + fullObject.getObjectMetadata().getContentType());
//            System.out.println("Content: " + logoStr2);
        }
        catch(AmazonServiceException e) {
            // The call was transmitted successfully, but Amazon S3 couldn't process 
            // it, so it returned an error response.
            e.printStackTrace();
        }
        catch(SdkClientException e) {
            // Amazon S3 couldn't be contacted for a response, or the client
            // couldn't parse the response from Amazon S3.
            e.printStackTrace();
        } catch (Exception e) {
			e.printStackTrace();
		}
	}

}
