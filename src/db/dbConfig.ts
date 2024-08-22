import mongoose from "mongoose";

export async function Connect() {
  try {
    await mongoose.connect("mongodb+srv://mongouser:XvZ8xNNfiISe1k12@cluster0.wfoyj.mongodb.net/todoappretryWrites=true&w=majority&appName=Cluster0", {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    } as any);

    const connection = await mongoose.connection;
    connection.on("connected", () => {
      console.log("MongoDB connected");
    });

    connection.on("error", (err) => {
      console.log("MongoDB connection error" + err);
      process.exit(1);
    });
  } catch (error) {
    console.log("something goes wrong!");
    console.log(error);
  }
}
